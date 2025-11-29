//
//  Category.swift
//  LOKEY
//
//  Created by Devin De Silva on 17/11/2025.
//

import Foundation

struct Category: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var description: String?
    var createdAt: Date = .now
    var isSystem: Bool = false  // for default categories
}
