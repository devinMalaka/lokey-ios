//
//  VaultData.swift
//  LOKEY
//
//  Created by Devin De Silva on 17/11/2025.
//

import Foundation

struct VaultData: Codable {
    var credentials: [Credential]
    var categories: [Category]
}
