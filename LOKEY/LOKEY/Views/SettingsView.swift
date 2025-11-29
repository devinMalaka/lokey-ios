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
    
    @AppStorage(UserDefaultsKey.appTheme)
    private var appThemeRaw: String = AppTheme.light.rawValue
    
    private var appTheme: AppTheme {
        get { AppTheme(rawValue: appThemeRaw) ?? .light }
        set { appThemeRaw = newValue.rawValue }
    }
    
    // Binding that reads/writes the @AppStorage-backed raw value without mutating self
    private var appThemeBinding: Binding<AppTheme> {
        Binding(
            get: { AppTheme(rawValue: appThemeRaw) ?? .light },
            set: { appThemeRaw = $0.rawValue }
        )
    }
    
    var body: some View {
        Form {
            Section("Security") {
                Toggle("Require biometrics on launch", isOn: $requireBiometricsOnLaunch)
                    .accessibilityHint("When off, the vault opens without FaceID or Touch ID")
            }
            
            Section("Feedback") {
                Toggle("Enable haptics", isOn: $enableHaptics)
                    .accessibilityHint("Vibration feedback on actions like unlock and copy")
            }
            
            Section("Appearance") {
                Picker("Theme", selection: appThemeBinding) {
                    ForEach(AppTheme.allCases) { theme in
                        Text(theme.displayName).tag(theme)
                    }
                }
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
    }
    
}

#Preview {
    SettingsView()
}
