//
//  RootView.swift
//  LOKEY
//
//  Created by Devin De Silva on 06/11/2025.
//

import SwiftUI

struct RootView: View {
    
    @Binding var isLocked: Bool
    
    var body: some View {
        Group {
            if isLocked {
                LockedView(onUnlock: { isLocked = false })
            } else {
                VaultListView(onLock: { isLocked = true })
            }
        }
    }
}

#Preview("Locked") {
    RootView(isLocked: .constant(true))
}

#Preview("Unlocked") {
    RootView(isLocked: .constant(false))
}
