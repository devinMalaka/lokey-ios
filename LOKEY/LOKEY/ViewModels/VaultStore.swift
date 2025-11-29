//
//  VaultStore.swift
//  LOKEY
//
//  Created by Devin De Silva on 08/11/2025.
//

import Foundation
import Combine

@MainActor
final class VaultStore: ObservableObject {
    @Published private(set) var items: [Credential] = []
    @Published private(set) var categories: [Category] = []
    
    //Keychain coordinates for the single-vault blob
    private let account = "lokey-vault"
    private let service = "com.devin.lokey"
    private let kc = KeychainService.shared
    
    // Default categories
    private let defaultCategories: [Category] = [
        Category(
            name: "Social Media",
            description: "Facebook, Instagram, X, TikTok…",
            isSystem: true
        ),
        Category(
            name: "Finance",
            description: "Banking, payments, crypto, trading…",
            isSystem: true
        ),
        Category(
            name: "Work",
            description: "Work-related accounts and tools.",
            isSystem: true
        )
    ]
    
    init() {
        load() // attempt to load on startup
    }

    // MARK: - Credential CRUD

    func add(_ c: Credential) {
        var item = c
        item.createdAt = .now
        item.updatedAt = .now
        items.insert(item, at: 0)
        persist()
    }

    func update(_ c: Credential) {
        if let i = items.firstIndex(where: { $0.id == c.id }) {
            var edited = c
            edited.updatedAt = .now
            items[i] = edited
            persist()
        }
    }

    /// Match List.onDelete signature without importing SwiftUI here.
    func delete(at offsets: IndexSet) {
        // Remove in descending order so indices stay valid
        for i in offsets.sorted(by: >) {
            items.remove(at: i)
        }
        persist()
    }
    
    // MARK: - Category CRUD
    
    func addCategory(_ category: Category) {
        categories.append(category)
        persist()
    }
    
    func updateCategory(_ category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
            persist()
        }
    }
    
    /// Delete a category and move effected credebtials to "Uncategorized" (categoryId = nil)
    func deleteCategory(_ category: Category) {
        //Remove the category
        categories.removeAll { $0.id == category.id }
        
        //clear category id of the effected credentials
        for i in items.indices {
            if items[i].categoryId == category.id {
                items[i].categoryId = nil
                items[i].updatedAt = .now
            }
        }
        persist()
    }
    
    // MARK: - Persistence
    
    private func load() {
        do {
            guard let data = try kc.load(account: account, service: service) else {
                // Fresh install:No data yet
                self.items = []
                self.categories = defaultCategories
                return
            }
            
            let decoder = JSONDecoder()
            
            // Try new format first: VaultData
            if let vaultData = try? decoder.decode(VaultData.self, from: data) {
                self.items = vaultData.credentials
                self.categories = vaultData.categories.isEmpty ? defaultCategories : vaultData.categories
                return
            }
            
            //if both decodes failed, start fresh but keep defaults
            self.items = []
            self.categories = defaultCategories
            
        } catch {
            // To prevent crashing if decoding fails
            print("Keychain load error:", error)
            self.items = []
            self.categories = defaultCategories
        }
    }
    
    private func persist() {
        do {
            let vault = VaultData(credentials: items, categories: categories)
            let data = try JSONEncoder().encode(vault)
            try kc.save(data: data, account: account, service: service)
        } catch {
            print("Keychain save error:", error)
        }
    }
}
