//
//  Haptics.swift
//  LOKEY
//
//  Created by Devin De Silva on 15/11/2025.
//

import SwiftUI
import UIKit

enum Haptics {
    private static var isEnabled: Bool {
        UserDefaults.standard.bool(forKey: UserDefaultsKey.enableHaptics)
    }
    
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        guard isEnabled else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isEnabled else {return}
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
}
