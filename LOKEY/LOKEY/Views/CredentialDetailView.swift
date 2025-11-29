//
//  CredentialDetailView.swift
//  LOKEY
//
//  Created by Devin De Silva on 14/11/2025.
//

import SwiftUI
import UIKit

/// Shows a single credential with reveal/hide and copy actions
struct CredentialDetailView: View {
    // local copy of the credential, so that the view can update after editing
    @State private var credential: Credential
    let categories: [Category]
    
    // Called when user saves changes from the edit credential sheet
    let onUpdate:  (Credential) -> Void
    
    // Called when the user confirms delete
    let onDelete: () -> Void
    
    @State private var isPasswordVisible = false
    @State private var isEditing = false
    @State private var showDeleteAlert = false
    
    @Environment(\.dismiss) private var dismiss
    
    // Custom init to seed the @State
    init(
        credential: Credential,
        categories: [Category],
        onUpdate: @escaping (Credential) -> Void,
        onDelete: @escaping () -> Void
    ) {
        _credential = State(initialValue: credential)
        self.categories = categories
        self.onUpdate = onUpdate
        self.onDelete = onDelete
    }
    
    
    var body: some View {
        Form {
            // MARK: - Account Section
            Section("Account") {
                HStack {
                    Text("Title")
                    Spacer()
                    Text(credential.title)
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Category")
                    Spacer()
                    Text(categoryLabel)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail )
                }

                
                HStack {
                    Text("Username")
                    Spacer()
                    Text(credential.username)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                    
                    Button {
                        Clipboard.copySecure(credential.username)
                        Haptics.impact(.light)
                    } label: {
                        Image(systemName: "doc.on.doc")
                    }
                    .buttonStyle(.borderless)
                    .accessibilityLabel("Copy Username")
                }
                
                HStack {
                    Text("Password")
                    Spacer()
                    Group {
                        if isPasswordVisible {
                            Text(credential.password)
                        } else {
                            Text(String(repeating: "•", count: max(credential.password.count, 8)))
                        }
                    }
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    
                    Button {
                        isPasswordVisible.toggle()
                        Haptics.impact(.light)
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                    }
                    .buttonStyle(.borderless)
                    .accessibilityLabel(isPasswordVisible ? "Hide Password" : "Show Password")
                    
                    Button {
                        Clipboard.copySecure(credential.password)
                        Haptics.impact(.light)
                    } label: {
                        Image(systemName: "doc.on.doc")
                    }
                    .buttonStyle(.borderless)
                    .accessibilityLabel("Copy Password")
                    
                    
                }
            }
            
            // MARK: - Notes
            if let notes = credential.notes, !notes.isEmpty {
                Section("Notes") {
                    Text(notes)
                }
            }
            
            // MARK: - Metadata
            Section("MetaData") {
                HStack {
                    Text("Created At")
                    Spacer()
                    Text(credential.createdAt.formatted(date: .abbreviated, time: .shortened))
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Updated At")
                    Spacer()
                    Text(credential.updatedAt.formatted(date: .abbreviated, time: .shortened))
                        .foregroundStyle(.secondary)
                }
            }
            
            // MARK: - Dangerous Actions
            Section {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Label("Delete credential", systemImage: "trash")
                }
            }
            
        }
        .navigationTitle("\(credential.title) Credentials")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    isEditing = true
                }
            }
        }
        // Edit flow
        .sheet(isPresented: $isEditing) {
            NavigationStack {
                AddEditCredentialView(mode: .edit(credential), categories: categories) { updated in
                    credential = updated
                    onUpdate(updated)
                }
            }
        }
        
        // Delete Confirmation
        .alert("Delete \(credential.title) credentials?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                onDelete()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }
    
    private var categoryLabel: String {
        if let id = credential.categoryId,
           let category = categories.first(where: { $0.id == id }) {
            return category.name
        } else {
            return "Uncategorized"
        }
    }
}

//#Preview {
//    let sample = Credential(
//        title: "Gmail",
//        username: "devindemalaka@gmail.com",
//        password: "testPassword",
//        notes: "personal email credentials"
//    )
//    NavigationStack {
//        CredentialDetailView(
//            credential: sample,
//            onUpdate: { _ in },
//            onDelete: {}
//        )
//    }
//}
