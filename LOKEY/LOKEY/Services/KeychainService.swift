//
//  KeychainService.swift
//  LOKEY
//
//  Created by Devin De Silva on 12/11/2025.
//

import Foundation
import Security

/// Simple error wrapper for keychain status codes.
enum KeyChainError: Error {
    case unExpectedStatus(OSStatus)
    
    var localizedDescription: String {
        switch self {
        case .unExpectedStatus(let status):
            if let message = SecCopyErrorMessageString(status, nil) as String? {
                return "Keychain error (\(status)): \(message)"
            } else {
                return "Keychain error with status: \(status)"
            }
        }
    }
}

final class KeychainService {
    static let shared =  KeychainService()
    private init() {}
    
    /// Save a blob of data into a single Keychain item (Replace any existing)
    func save(data: Data, account: String, service: String) throws {
        // Delete existing item if present
        let baseQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service
        ]
        
        SecItemDelete(baseQuery as CFDictionary)
        
        // Re-add with desired attributes
        var addQuery = baseQuery
        addQuery[kSecValueData as String] = data
        
        // Only accessible when device is unlocked
        addQuery[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeyChainError.unExpectedStatus(status) }
    }
    
    
    /// Load data for the given account/service. Returns nil if not found
    func load(account: String, service: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var out: AnyObject?
        let status =  SecItemCopyMatching(query as CFDictionary, &out)
        
        if status == errSecItemNotFound { return nil }
        guard status ==  errSecSuccess, let data = out as? Data else {
            throw KeyChainError.unExpectedStatus(status)
        }
        return data
    }
    
    
    /// Delete the item entirely
    func delete(account: String, service: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeyChainError.unExpectedStatus(status)
        }
    }
}
