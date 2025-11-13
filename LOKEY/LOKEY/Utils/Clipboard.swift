//
//  Clipboard.swift
//  LOKEY
//
//  Created by Devin De Silva on 13/11/2025.
//

import UIKit

enum Clipboard {
    /// Copy text to clipboard and clear the clipboard after 60  seconds by default
    static func copySecure(_ text: String, cleaAfter seconds: TimeInterval = 60) {
        UIPasteboard.general.string = text
        
        // Schedule an auto-clear that only clears if content is unchanged (Avoid nuking user's own later copy)
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            if UIPasteboard.general.string == text {
                UIPasteboard.general.string = ""
            }
        }
    }
}
