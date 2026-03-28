# Mac Coach — macOS Menubar App

## Quick Reference
- **Stack**: Swift 6 + SwiftUI, macOS 14+ (Sonoma)
- **Type**: Menubar app (NSStatusItem + NSPopover), no dock icon
- **Bundle ID**: com.sadeam.maccoach

## Build & Run
```bash
cd ~/ai-product-studio/projects/mac-coach/src
xcodegen generate          # Regenerate .xcodeproj from project.yml
xcodebuild -project MacCoach.xcodeproj -scheme MacCoach -configuration Debug build
open build/Debug/MacCoach.app   # Or just build+run in Xcode
```

## Architecture
- **App/**: App entry point + AppDelegate (NSStatusItem/NSPopover setup)
- **Views/**: SwiftUI views — PopoverContentView is root, branches to Welcome or Dashboard
- **Models/**: Codable data models (Lesson, Card, ShortcutEntry)
- **Stores/**: State management — ProgressStore (UserDefaults), LocaleManager (AR/EN), ContentStore (JSON loader)
- **Resources/Content/**: Bundled JSON files (lessons.json, shortcuts.json)
- **Utilities/**: Global keyboard shortcut (Slice 5)

## Key Patterns
- `@Observable` for state (ProgressStore, LocaleManager) — passed via `.environment()`
- All content is bilingual — models have EN/AR fields with `func title(for language:)` accessors
- RTL handled via `.environment(\.layoutDirection, ...)` based on LocaleManager.isArabic
- LSUIElement = true in Info.plist (hides dock icon, menubar-only app)
- App Sandbox enabled for Mac App Store distribution

## Content Format
Lessons and shortcuts are in Resources/Content/*.json. See Models/ for the exact schema.
