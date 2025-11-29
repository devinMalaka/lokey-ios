//
//  VaultListView.swift
//  LOKEY
//
//  Created by Devin De Silva on 06/11/2025.
//

import SwiftUI
import UIKit


private enum CategoryFilter: Equatable {
    case all
    case uncategorized
    case category(UUID)
}

struct VaultListView: View {
    @StateObject private var store = VaultStore()
    @State private var showAddMenu = false
    @State private var showAddCategory = false
    @State private var showAddCredential = false
    @State private var query = ""
    @State private var selectedFilter: CategoryFilter = .all
    
    @AppStorage(UserDefaultsKey.requireBiometricsOnLaunch)
    private var requireBiometricsOnLaunch: Bool = true
    
    @AppStorage(UserDefaultsKey.appTheme)
    private var appThemeRaw: String = AppTheme.light.rawValue
    
    private var appTheme: AppTheme {
        AppTheme(rawValue: appThemeRaw) ?? .light
    }
    
    var onLock: () -> Void
    var onOpenSettings: () -> Void
    
    
    private var filtered: [Credential] {
        // Filter by category
        let byCategory: [Credential]
        switch selectedFilter {
        case .all:
            byCategory = store.items
        case .uncategorized:
            byCategory = store.items.filter { $0.categoryId == nil }
        case .category(let id):
            byCategory = store.items.filter { $0.categoryId == id }
        }
        
        // Filter by search
        guard !query.isEmpty else { return byCategory }
        return byCategory.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
            $0.username.localizedCaseInsensitiveContains(query)
        }
    }
    
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CategoryFilterBar(
                    categories: store.categories,
                    selectedFilter: $selectedFilter
                )
                Group {
                    if filtered.isEmpty {
                        ContentUnavailableView(
                            "No credentials",
                            systemImage: "key.fill",
                            description: Text("Tap + to add your first item.")
                        )
                    } else {
                        List {
                            ForEach(filtered) { c in
                                NavigationLink {
                                    CredentialDetailView(
                                        credential: c,
                                        categories: store.categories,
                                        onUpdate: { updated in
                                            store.update(updated)
                                        },
                                        onDelete: {
                                            if let index = store.items.firstIndex(where: { $0.id == c.id }) {
                                                store.delete(at: IndexSet(integer: index))
                                            }
                                        }
                                    )
                                } label: {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(c.title).font(.headline)
                                        Text(c.username).foregroundStyle(.secondary)
                                        Text("Updated \(c.updatedAt.formatted(date: .abbreviated, time: .shortened))")
                                            .font(.caption2)
                                            .foregroundStyle(.tertiary)
                                    }
                                }
                                .contextMenu {
                                    Button {
                                        Clipboard.copySecure(c.username)
                                        Haptics.impact(.light)
                                    } label: {
                                        Label("Copy Username", systemImage: "doc.on.doc")
                                    }
                                    Button {
                                        Clipboard.copySecure(c.password)
                                        Haptics.impact(.light)
                                    } label: {
                                        Label("Copy Password", systemImage: "doc.on.doc")
                                    }
                                }
                            }
                            .onDelete { offsets in
                                Haptics.impact(.light)
                                store.delete(at: offsets)
                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                            }
                        }
                    }
                }
            }
            
            .navigationTitle("Vault")
            .toolbar {
                // Left: Lock + Settings
                ToolbarItemGroup(placement: .topBarLeading) {
                    if requireBiometricsOnLaunch {
                        Button { onLock() } label: {
                            Image(systemName: "lock")
                        }
                        .accessibilityLabel("Lock app")
                    }
                    
                    Button {
                        onOpenSettings()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityLabel("Open settings")
                }
                
                // Right: Add
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Add Credential") { showAddCredential = true }
                        Button("Add Category") { showAddCategory = true }
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                }
            }
            .searchable(text: $query)
            .sheet(isPresented: $showAddCredential) {
                NavigationStack {
                    AddEditCredentialView(mode: .add, categories: store.categories) { newItem in
                        store.add(newItem)
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }
                }
                .appTheme(appTheme) // ensure add/edit sheet follows theme live
            }
            .sheet(isPresented: $showAddCategory) {
                NavigationStack {
                    AddEditCategoryView(mode: .add) { newCategory in
                        store.addCategory(newCategory)
                    }
                }
            }
        }
    }
}

// MARK: - Category Filter Bar

private struct CategoryFilterBar: View {
    let categories: [Category]
    @Binding var selectedFilter: CategoryFilter
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Spacer().frame(width: 10)
                CategoryChip(
                    label: "All",
                    isSelected: selectedFilter == .all) {
                        Haptics.impact(.light)
                        selectedFilter = .all
                    }
                
                ForEach(categories) { category in
                    CategoryChip(
                        label: category.name,
                        isSelected: selectedFilter == .category(category.id)) {
                            Haptics.impact(.light)
                            selectedFilter = .category(category.id)
                        }
                }
                
                CategoryChip(
                    label: "Uncategorized",
                    isSelected: selectedFilter == .uncategorized) {
                        Haptics.impact(.light)
                        selectedFilter = .uncategorized
                    }
            }
            .padding(.vertical, 10)
        }
    }
    
    
}

// MARK: - Category Chip

private struct CategoryChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.accentColor : Color.secondary.opacity(0.4), lineWidth: 1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.accentColor : Color.secondary.opacity(0.4), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}


