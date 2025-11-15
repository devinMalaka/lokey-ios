//
//  SettingsView.swift
//  LOKEY
//
//  Created by Devin De Silva on 15/11/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(UserDefaultsKey.requireBiometricsOnLaunch)
    private var requireBiometricsOnLaunch: Bool = true
    
    @AppStorage(UserDefaultsKey.enableHaptics)
    private var enableHaptics = true
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Security") {
                    Toggle("Require biometrics on launch", isOn: $requireBiometricsOnLaunch)
                        .accessibilityHint("When off, the vault opens without FaceID or Touch ID")
                }
                
                Section("Feedback") {
                    Toggle("Enable haptics", isOn: $enableHaptics)
                        .accessibilityHint("Vibration feedback on actions like unlock and copy")
                }
                
                Section("About") {
                    HStack {
                        Text("App")
                        Spacer()
                        Text("LOKEY").foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("0.1.0").foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Developer")
                        Spacer()
                        Text("Devin De Silva").foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
        
    }
    
}

#Preview {
    SettingsView()
}
