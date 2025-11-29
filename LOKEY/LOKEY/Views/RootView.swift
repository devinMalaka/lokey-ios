//
//  RootView.swift
//  LOKEY
//
//  Created by Devin De Silva on 06/11/2025.
//

import SwiftUI

struct RootView: View {
    
    @Binding var isLocked: Bool
    @Binding var showSettings: Bool
    
    @AppStorage(UserDefaultsKey.requireBiometricsOnLaunch)
    private var requireBiometricsOnLaunch: Bool = true
    
    var body: some View {
        Group {
            if isLocked && requireBiometricsOnLaunch {
                LockedView(onUnlock: { isLocked = false })
            } else {
                VaultListView(
                    onLock: {
                    // If biometrics are disabled, lockingjust shows vault again
                    if requireBiometricsOnLaunch {
                        isLocked = true
                    } else {
                        isLocked = false
                    }
                    
                },
                    onOpenSettings: {
                        showSettings = true
                    }
                )
            }
        }
    }
}

//#Preview("Locked") {
//    RootView(isLocked: .constant(true))
//}
//
//#Preview("Unlocked") {
//    RootView(isLocked: .constant(false))
//}
