//
//  Credential.swift
//  LOKEY
//
//  Created by Devin De Silva on 07/11/2025.
//

import Foundation

struct Credential: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var username: String
    var password: String
    var notes: String? = nil
    var createdAt: Date = .now
    var updatedAt: Date = .now
}
