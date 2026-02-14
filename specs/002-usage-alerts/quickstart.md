# Quickstart: Usage Alerts Feature

## Overview

Add configurable usage alert thresholds with per-model settings, alert history, and snooze functionality to the MiniMax Usage Checker macOS app.

## New Components

### Files to Create

| File | Purpose |
|------|---------|
| `AlertSettingsManager.swift` | Manages alert settings persistence |
| `AlertHistoryManager.swift` | Manages alert history storage |
| `AlertModels.swift` | Data models (AlertSettings, AlertHistoryEntry) |
| `AlertSettingsView.swift` | SwiftUI settings view |

### Files to Modify

| File | Changes |
|------|---------|
| `NotificationManager.swift` | Add configurable threshold support |
| `UsageViewModel.swift` | Add alert settings to published state |
| `ContentView.swift` | Add Alerts tab/section |

## Getting Started

### 1. Build the project first

```bash
xcodebuild -project minimax-usage-checker.xcodeproj \
  -scheme minimax-usage-checker \
  -configuration Debug build
```

### 2. Run existing tests

```bash
xcodebuild test -project minimax-usage-checker.xcodeproj \
  -scheme minimax-usage-checker
```

### 3. Start implementing

- Step 1: Add `AlertModels.swift` with data structures
- Step 2: Implement `AlertSettingsManager` for UserDefaults persistence
- Step 3: Implement `AlertHistoryManager` for history storage
- Step 4: Update `NotificationManager` to use configurable thresholds
- Step 5: Create `AlertSettingsView` SwiftUI component
- Step 6: Add Alerts section to main app navigation
- Step 7: Add unit tests for new managers

## Key Implementation Notes

- All new managers should be singletons (like existing NotificationManager)
- Use `@MainActor` for any code that updates UI
- Store settings with keys prefixed `alert_` to avoid collisions
- Alert history auto-prunes at 100 entries
- Snooze is global (applies to all models)

## Testing Checklist

- [ ] Settings persist after app restart
- [ ] Per-model threshold overrides work correctly
- [ ] Alert history shows past alerts
- [ ] Snooze prevents notifications during active period
- [ ] Validation prevents invalid threshold configurations
- [ ] Custom messages appear in notifications
