//
//  VaultListView.swift
//  LOKEY
//
//  Created by Devin De Silva on 06/11/2025.
//

import SwiftUI
import UIKit

struct VaultListView: View {
    @StateObject private var store = VaultStore()
    @State private var showAdd = false
    @State private var showSettings = false
    @State private var query = ""
    
    @AppStorage(UserDefaultsKey.requireBiometricsOnLaunch)
    private var requireBiometricsOnLaunch: Bool = false
    
    var onLock: () -> Void

    private var filtered: [Credential] {
        guard !query.isEmpty else { return store.items }
        return store.items.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
            $0.username.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        NavigationStack {
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
                                    onUpdate: { updated in
                                        store.update(updated)
                                        
                                    },
                                    onDelete: {
                                        // Find the index in the store and delete that item
                                        if let index = store.items.firstIndex(where: {$0.id == c.id}) {
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
                            // Haptic for delete gesture
                            Haptics.impact(.light)
                            store.delete(at: offsets)
                            // Optional: success confirmation after delete
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                        }
                    }
                }
            }
            .navigationTitle("Vault")
            .toolbar {
                // Left:  Lock + Settings menu
                ToolbarItemGroup(placement: .topBarLeading) {
                    if requireBiometricsOnLaunch {
                        Button { onLock() } label: { Image(systemName: "lock") }
                            .accessibilityLabel("Lock app")
                    }
                    
                    Button { showSettings = true } label: { Image(systemName: "gearshape") }
                        .accessibilityLabel("Open settings")
                }
                
                // Right: Add credentials option
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Haptic on tapping Add
                        Haptics.impact(.light)
                        showAdd = true
                    } label: { Image(systemName: "plus") }
                        .accessibilityLabel("Add credential")
                }
            }
            .searchable(text: $query)
            .sheet(isPresented: $showAdd) {
                NavigationStack {
                    AddEditCredentialView(mode: .add) { newItem in
                        store.add(newItem)
                        // Success haptic after add completes
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
}

