//
//  AppTheme.swift
//  LOKEY
//
//  Created by Devin De Silva on 16/11/2025.
//

import SwiftUI
import UIKit

enum AppTheme: String, CaseIterable, Identifiable {
    case light
    case dark
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
    
}

struct ThemeModifier: ViewModifier {
    let theme: AppTheme
    
    func body(content: Content) -> some View {
        switch theme {
        case .light:
            content.preferredColorScheme(.light)
        case .dark:
            content.preferredColorScheme(.dark)
        }
    }
}

extension View {
    func appTheme(_ theme: AppTheme) -> some View {
        self.modifier(ThemeModifier(theme: theme))
    }
}
