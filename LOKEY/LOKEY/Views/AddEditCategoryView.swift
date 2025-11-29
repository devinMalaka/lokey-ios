//
//  AddEditCategoryView.swift
//  LOKEY
//
//  Created by Devin De Silva on 24/11/2025.
//

import SwiftUI

struct AddEditCategoryView: View {
    enum Mode {
        case add
        case edit(Category)
    }
    
    let mode: Mode
    let onSave: (Category) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var description: String
    @State private var showValidationError = false
    
    private var isEditing: Bool {
        if case .edit = mode { return true }
        return false
    }
    
    // Custom init to seed state from existing category when editing
    init(mode: Mode, onSave: @escaping (Category) -> Void) {
        self.mode = mode
        self.onSave = onSave
        
        switch mode {
        case .add:
            _name = State(initialValue: "")
            _description = State(initialValue: "")
        case .edit(let category):
            _name = State(initialValue: category.name)
            _description = State(initialValue: category.description ?? "")
        }
    }
    
    var body: some View {
        Form {
            Section("Details") {
                TextField("Category Name", text: $name)
                    .textInputAutocapitalization(.words)
                TextField("Description (Optional)", text: $description, axis: .vertical)
                    .lineLimit(1...3)
            }
            
            if showValidationError {
                Section{
                    Text("Please enter a category name.")
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle(isEditing ? "Edit Category" : "Add Category")
        .toolbar{
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }
    
    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else {
            showValidationError = true
            return
        }
        
        let desc = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let descValue = desc.isEmpty ? nil : desc
        
        let result: Category
        switch mode {
        case .add:
            result = Category(
                name: trimmedName,
                description: descValue,
                isSystem: false
            )
        case .edit(let existing):
            result = Category(
                id: existing.id,
                name: trimmedName,
                description: descValue,
                createdAt: existing.createdAt,
                isSystem: existing.isSystem
                
            )
        }
        
        onSave(result)
        Haptics.notification(.success)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        AddEditCategoryView(mode: .add) { _ in }
    }
}
