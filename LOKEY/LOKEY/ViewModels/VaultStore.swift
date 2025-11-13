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
    
    //Keychain coordinates for the single-vault blob
    private let account = "lokey-vault"
    private let service = "com.devin.lokey"
    private let kc = KeychainService.shared
    
    init() {
        load() // attempt to load on startup
    }

    // MARK: - CRUD

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
    
    private func load() {
        do {
            if let data = try kc.load(account: account, service: service) {
                let decoded = try JSONDecoder().decode([Credential].self, from: data)
                self.items = decoded
            } else {
                self.items = []
            }
        } catch {
            // To prevent crashing if decoding fails
            print("Keychain load error:", error)
            self.items = []
        }
    }
    
    private func persist() {
        do {
            let data = try JSONEncoder().encode(items)
            try kc.save(data: data, account: account, service: service)
        } catch {
            print("Keychain save error:", error)
        }
    }
}
