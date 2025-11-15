//
//  LOKEYApp.swift
//  LOKEY
//
//  Created by Devin De Silva on 05/11/2025.
//

import SwiftUI

@main
struct LOKEYApp: App {
    
//    App-wide lock state (if true show lock screen)
    @State private var isLocked = true
    @Environment(\.scenePhase) private var scenePhase
    
    @AppStorage(UserDefaultsKey.requireBiometricsOnLaunch)
    private var requireBiometricsOnLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            RootView(isLocked: $isLocked)
        }
        
//        Auto lock whenever the app goes to background
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background {
                // Only lock on background if user want biometrics
                if requireBiometricsOnLaunch {
                    isLocked = true
                }
            }
        }
    }
}
