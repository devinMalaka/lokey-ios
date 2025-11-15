//
//  LockedView.swift
//  LOKEY
//
//  Created by Devin De Silva on 06/11/2025.
//

import SwiftUI
import LocalAuthentication
import UIKit

struct LockedView: View {
    var onUnlock: () -> Void
    @State private var isAuthenticating = false
    @State private var errorMessage: String?
    @State private var biometryType: LABiometryType = .none
    
    private var unlockLabelText: String {
        if isAuthenticating {
            return "Authenticating..."
        }
        switch biometryType {
        case .faceID:
            return "Unlock with Face ID"
        case .touchID:
            return "Unlock with Touch ID"
        default:
            return "Unlock"
        }
    }
    
    var body: some View {
        VStack(spacing: 25) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 72))
                .symbolRenderingMode(.hierarchical)
            
            Text("LOKEY")
                .font(.largeTitle).bold()
            
            Text("Yor secrets, safely stored")
                .foregroundStyle(.secondary)
            
            Button {
                Task {
                    await runAuthentication()
                }
            } label: {
                HStack {
                    if isAuthenticating { ProgressView() }
                    Text(unlockLabelText)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isAuthenticating)
            
            if let errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding()
        .task {
            // Determine biometry type once on appear
            updateBiometryType()
            // Try auto auth on appear
            await runAuthentication()
        }
    }
    
    private func updateBiometryType() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            biometryType = context.biometryType
        } else {
            biometryType = .none
        }
    }
    
    @MainActor
    private func runAuthentication() async {
        guard !isAuthenticating else { return }
        isAuthenticating = true; defer { isAuthenticating = false }
        
        let ok = await AuthService().authenticate(reason: "Unlock your vault")
        if ok {
            // Subtle haptic on successful unlock
            Haptics.impact(.light)
            onUnlock()
        } else {
            errorMessage = "Failed to unlock. Please try again."
        }
    }
}
