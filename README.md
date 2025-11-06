# LOKEY 🔐
**Offline password vault for iOS** — built with **SwiftUI**, **Keychain**, and **Face ID**.  
No accounts. No cloud. Your secrets, safely stored on device.

![Platform](https://img.shields.io/badge/iOS-17%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![UI](https://img.shields.io/badge/UI-SwiftUI-51A9FF)
![CI](https://img.shields.io/badge/CI-GitHub%20Actions-success)

## ✨ Features (MVP)
- Face ID / Touch ID **app lock**
- **Secure storage** via iOS Keychain (no plaintext on disk)
- Add / Edit / Delete credentials (title, username, password, notes)
- **Copy to clipboard** with auto-clear (60s)
- **Search** by title or username
- Auto-lock on background

## 🧱 Tech Stack
- **SwiftUI** (UI), **MVVM-light**
- **LocalAuthentication** (biometrics)
- **Security / Keychain** (persistence)
- SwiftLint + SwiftFormat (style & hygiene)
- GitHub Actions (build & tests)

## 🔐 Security Model
- Data stored **only** in Keychain (encrypted by iOS)
- No network, no analytics by default
- Clipboard auto-clear after copy
- Re-lock on background

> *Future (not in MVP):* password generator, export/import (encrypted), iCloud sync, breach checks.

## 🗂 Project Structure
```bash
LOKEY/
├─ App/ # app entry & scene handling
├─ Models/ # Credential, etc.
├─ ViewModels/ # VaultStore (state & persistence)
├─ Views/ # SwiftUI screens
├─ Services/ # AuthService, KeychainService, Clipboard
├─ Utils/ # helpers
└─ Tests/ # unit tests
```


## 🚀 Getting Started
1. Open in Xcode 15+ (`LOKEY.xcodeproj` or workspace)
2. Select **iPhone 15** simulator
3. Build & run

## 🧪 Testing
```bash 
xcodebuild -scheme LOKEY -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 15' test
```

## 📸 Screenshots

Add after MVP
-Lock screen
-Vault list
-Add/Edit form
-Detail + Copy

## 🏷️ License
MIT — see LICENSE
.

## 🙌 Credits

By Devin De Silva. “LOKEY” (Low-key & Lock+Key) — keep it LOKEY.
