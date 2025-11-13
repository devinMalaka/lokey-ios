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
    var onSave: (Credential) -> Void
    @Environment(\.dismiss) private var dismiss
    
    // Form State
    @State private var title: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var notes: String = ""
    
    init(mode: Mode, onSave: @escaping (Credential) -> Void) {
        self.mode = mode
        self.onSave = onSave
        if case let .edit(c) = mode {
            _title = State(initialValue: c.title)
            _username = State(initialValue: c.username)
            _password = State(initialValue: c.password)
            _notes = State(initialValue: c.notes ?? "")
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
                Button("Save", action: save)
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
        let base = Credential(
            title: title.trimmingCharacters(in: .whitespaces),
            username: username.trimmingCharacters(in: .whitespaces),
            password: password,
            notes: notes.isEmpty ? nil : notes
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
    AddEditCredentialView(mode: .add) { _ in }
}
