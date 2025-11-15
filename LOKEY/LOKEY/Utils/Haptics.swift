//
//  Haptics.swift
//  LOKEY
//
//  Created by Devin De Silva on 15/11/2025.
//

import SwiftUI
import UIKit

enum Haptics {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
            guard UserDefaults.standard.bool(forKey: UserDefaultsKey.enableHaptics) else { return }
            UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard UserDefaults.standard.bool(forKey: UserDefaultsKey.enableHaptics) else { return }
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
}
