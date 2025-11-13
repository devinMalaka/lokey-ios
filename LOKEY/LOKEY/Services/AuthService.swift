//
//  AuthService.swift
//  LOKEY
//
//  Created by Devin De Silva on 06/11/2025.
//

import LocalAuthentication

enum AuthError: Error {
    case unavailable
    case failed
}

final class AuthService {
    // Attempts biometric auth. Returns true on success, false if user cancels or device unavailable.
    func authenticate(reason: String = "Unlock LOKEY") async -> Bool {
        let context = LAContext()
        var error: NSError?
        
        // Check availability (Face ID/ Touch ID)
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return false
        }
        
        do {
            // Shows the system Face ID/ Touvh ID sheets
            let ok = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
            return ok
        } catch {
            // User cancelled, failed or system error
            return false
        }
    }
    
}
