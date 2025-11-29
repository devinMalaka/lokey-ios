//
//  AddEditCredentialView.swift
//  LOKEY
//
//  Created by Devin De Silva on 08/11/2025.
//

import SwiftUI

struct AddEditCredentialView: View {
    enum Mode { case add, edit(Credential) }
    
    let mode: Mode
    var categories: [Category]
    var onSave: (Credential) -> Void
    @Environment(\.dismiss) private var dismiss
    
    // Form State
    @State private var title: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var notes: String = ""
    @State private var selectedCategoryId: UUID?
    @State private var showValidationError: Bool = false
    
    init(mode: Mode, categories: [Category], onSave: @escaping (Credential) -> Void) {
        self.mode = mode
        self.categories = categories
        self.onSave = onSave
        
        switch mode {
        case .add:
            _title = State(initialValue: "")
            _username = State(initialValue: "")
            _password = State(initialValue: "")
            _notes = State(initialValue: "")
            _selectedCategoryId = State(initialValue: nil)
        case .edit(let credential):
            _title = State(initialValue: credential.title)
            _username = State(initialValue: credential.username)
            _password = State(initialValue: credential.password)
            _notes = State(initialValue: credential.notes ?? "")
            _selectedCategoryId = State(initialValue: credential.categoryId)
        }
        
    }
    
    var body: some View {
        Form {
            Section("Account") {
                TextField("Title (e.g. Gmail)", text: $title)
                    .textInputAutocapitalization(.words)
                TextField("Username", text: $username)
                    .textInputAutocapitalization(.never)
                    .textContentType(.username)
                TextField("Password", text: $password)
                    .textContentType(.password)
            }
            Section("Category") {
                Picker("Category", selection: $selectedCategoryId) {
                    Text("None").tag(UUID?.none)
                    
                    ForEach(categories) { category in
                        Text(category.name)
                            .tag(Optional(category.id))
                    }
                }
            }
            Section("Notes") {
                TextField("Optional notes", text: $notes, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }
            
        }
        .navigationTitle(modeTitle)
        .toolbar{
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
                    .disabled(!isValid)
            }
        }
    }
    
    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !username.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.isEmpty
    }
    
    private var modeTitle: String {
        switch mode { case .add: "Add Credential"; case .edit: "Edit Credential" }
    }
    
    private func save() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        let trimmedUserName = username.trimmingCharacters(in: .whitespaces)
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let base = Credential(
            title: trimmedTitle,
            username: trimmedUserName,
            password: password,
            notes: trimmedNotes.isEmpty ? nil : trimmedNotes,
            categoryId: selectedCategoryId
        )
        
        switch mode {
        case .add:
            onSave(base)
        case .edit(let existing):
            var updated = base
            updated.id = existing.id
            updated.createdAt = existing.createdAt
            onSave(updated)
        }
        Haptics.notification(.success)
        dismiss()
    }
}





// MARK: - Preview
#Preview {
    // Sample credential for edit mode preview
    let sample = Credential(
        title: "Gmail",
        username: "devin@gmail.com",
        password: "••••••••",
        notes: "Personal email account"
    )

    // Return a NavigationStack so it matches how it's used in the app
//    NavigationStack {
//        VStack {
//            // Preview Add mode
//            AddEditCredentialView(mode: .add) { _ in }
//                .previewDisplayName("Add Credential")
//
//            Divider()
//
//            // Preview Edit mode
//            AddEditCredentialView(mode: .edit(sample)) { _ in }
//                .previewDisplayName("Edit Credential")
//        }
//        .padding()
//    }
//    AddEditCredentialView(mode: .add) { _ in }
}
