# AGENTS.md - MiniMax Usage Checker

This file provides guidelines for AI agents operating in this repository.

## Project Overview

A native macOS application for monitoring MiniMax AI API usage in real-time. Features a dashboard with usage charts, per-model breakdowns, historical data tracking, and push notifications when usage thresholds are exceeded.

- **Project Type**: Native macOS application (Swift/SwiftUI)
- **Minimum macOS**: 12.0 (Monterey)
- **Swift Version**: 5.9+
- **Xcode Version**: 15.0+
- **Architecture**: MVVM (Model-View-ViewModel)
- **Testing Frameworks**: Swift Testing (unit tests), XCTest (UI tests)
- **App Sandbox**: Enabled with network client access

## Build & Run Commands

### Using Xcode (Recommended)

```bash
# Open project in Xcode
open minimax-usage-checker.xcodeproj

# Build the project (Cmd + B in Xcode)
# Run the app (Cmd + R in Xcode)
```

### Using xcodebuild (Command Line)

```bash
# Build for macOS (Debug)
xcodebuild -project minimax-usage-checker.xcodeproj -scheme minimax-usage-checker -configuration Debug build

# Build for release
xcodebuild -project minimax-usage-checker.xcodeproj -scheme minimax-usage-checker -configuration Release build

# Build without code signing (for CI)
xcodebuild -project minimax-usage-checker.xcodeproj -scheme minimax-usage-checker -configuration Debug build CODE_SIGNING_ALLOWED=NO
```

### Running Tests

```bash
# Run all tests
xcodebuild test -project minimax-usage-checker.xcodeproj -scheme minimax-usage-checker

# Run unit tests only
xcodebuild test -project minimax-usage-checker.xcodeproj -scheme minimax-usage-checker -only-testing:minimax_usage_checkerTests

# Run UI tests
xcodebuild test -project minimax-usage-checker.xcodeproj -scheme minimax-usage-checker -only-testing:minimax-usage-checkerUITests -destination 'platform=macOS'

# Run a specific test
xcodebuild test -project minimax-usage-checker.xcodeproj -scheme minimax-usage-checker -only-testing:minimax_usage_checkerTests/minimax_usage_checkerTests/example
```

---

## File Structure

```
minimax-usage-checker/
├── minimax-usage-checker/
│   ├── minimax_usage_checkerApp.swift    # App entry point (@main)
│   ├── ContentView.swift                 # Root view with navigation
│   ├── UsageViewModel.swift              # ViewModel (business logic, state, persistence)
│   ├── MiniMaxAPIService.swift           # API layer (singleton)
│   ├── CodingPlanModels.swift            # Data models (Codable structs)
│   ├── NotificationManager.swift         # Local notifications (singleton)
│   ├── DesignSystem/                     # Design tokens & types
│   │   ├── DesignTokens.swift            # Colors, spacing, typography, shadows
│   │   ├── Animations.swift              # Animation extensions
│   │   ├── UsageStatus.swift             # Safe/Warning/Critical states
│   │   ├── EmptyStateType.swift          # Enum for empty states
│   │   └── ErrorStateType.swift          # Enum for error states
│   ├── Views/                            # Main app views
│   │   ├── MainView.swift                # Tab container
│   │   ├── DashboardView.swift            # Dashboard overview
│   │   ├── UsageView.swift               # Per-model usage details
│   │   ├── HistoryView.swift             # Historical data
│   │   └── OnboardingView.swift          # API key entry
│   ├── Components/                       # Reusable UI components
│   │   ├── CircularProgressView.swift    # Circular progress indicator
│   │   ├── LinearProgressView.swift      # Linear progress bar
│   │   ├── ModelCard.swift               # Model detail card
│   │   ├── ModelStatusList.swift         # List of model statuses
│   │   ├── ModelStatusRow.swift           # Single model status row
│   │   ├── PrimaryUsageIndicator.swift   # Main usage display
│   │   ├── StatCard.swift                # Statistics card
│   │   ├── StatsOverview.swift           # Stats overview panel
│   │   ├── TabBar.swift                  # Tab navigation bar
│   │   ├── TimeRangePicker.swift         # Time range selector
│   │   ├── TimelineChart.swift           # Usage timeline chart
│   │   ├── EmptyStateView.swift          # Empty state display
│   │   ├── ErrorStateView.swift          # Error state display
│   │   ├── LoadingStateView.swift        # Loading spinner
│   │   └── TooltipView.swift             # Tooltip component
│   ├── minimax-usage-checker.entitlements # App sandbox config
│   └── Assets.xcassets/                  # App icons & colors
├── minimax-usage-checkerTests/
│   └── minimax_usage_checkerTests.swift  # Unit tests (Swift Testing)
├── minimax-usage-checkerUITests/
│   ├── minimax_usage_checkerUITests.swift        # UI tests (XCTest)
│   └── minimax_usage_checkerUITestsLaunchTests.swift
├── .github/workflows/
│   └── build.yml                         # CI: Build on push to master
└── README.md
```

---

## Code Style Guidelines

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Types (struct, class, enum) | PascalCase | `UsageViewModel`, `ModelRemain` |
| Functions & Methods | camelCase | `fetchUsage()`, `startAutoRefresh()` |
| Variables & Properties | camelCase | `apiKey`, `modelRemains` |
| Enums (type) | PascalCase | `TimeRange`, `APIError` |
| Enum Cases | PascalCase | `.today`, `.week` |
| Constants | camelCase | `warningThreshold` |

### Swift Language Guidelines

#### 1. Imports
Group imports: Foundation → System frameworks → Third-party

```swift
import Foundation       // Standard library
import Combine         // System framework
import SwiftUI         // UI framework
import Charts          // Data visualization
import UserNotifications
```

#### 2. Type Annotations
- Use explicit types for function parameters and return types
- Let Swift infer types for local variables when obvious

```swift
// Good: Explicit for public API
func fetchUsage(apiKey: String) async throws -> CodingPlanResponse

// Good: Inferred for local variables
let snapshots: [SnapshotData] = []  // Explicit when initializing empty
let filtered = snapshots.filter { ... }  // Inferred
```

#### 3. Access Control
- Use `private` by default
- Use `fileprivate` for shared implementation within a file
- Use `@Published` for observable properties in ViewModels

```swift
@MainActor
class UsageViewModel: ObservableObject {
    @Published var modelRemains: [ModelRemain] = []  // Observable
    private var timer: Timer?  // Private implementation
}
```

#### 4. Error Handling
Use custom error enums conforming to `LocalizedError`:

```swift
enum APIError: LocalizedError {
    case invalidURL
    case noAPIKey
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noAPIKey:
            return "No API key configured"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
```

#### 5. Async/Await
- Use `async/await` for asynchronous operations
- Use `@MainActor` for UI-related code
- Wrap async calls in `Task` when calling from sync context

```swift
func fetchUsage() async {
    do {
        let response = try await MiniMaxAPIService.shared.fetchUsage(apiKey: apiKey)
        // Handle success
    } catch let error as APIError {
        // Handle specific error
    }
}

// Starting async work from sync context
Task {
    await viewModel.fetchUsage()
}
```

#### 6. SwiftUI Patterns

**ViewModels**:
- Mark with `@MainActor`
- Inherit from `ObservableObject`
- Use `@Published` for observable state

```swift
@MainActor
class UsageViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var modelRemains: [ModelRemain] = []
}
```

**Views**:
- Use `@StateObject` when creating/owning a ViewModel
- Use `@ObservedObject` when injecting a ViewModel
- Use `@State` for local view state
- Use `@Binding` for two-way binding
- Prefer `some View` for function returns

```swift
struct ContentView: View {
    @StateObject private var viewModel = UsageViewModel()  // Create
    @State private var selectedTab: Tab = .dashboard       // Local state
    
    var body: some View { ... }
}
```

#### 7. Property Wrappers

| Wrapper | Usage |
|---------|-------|
| `@Published` | Observable properties in ObservableObject |
| `@State` | Local view state (private) |
| `@Binding` | Two-way binding to parent state |
| `@StateObject` | Create and own an ObservableObject |
| `@ObservedObject` | Inject an ObservableObject |
| `@Environment` | Access environment values |

#### 8. Computed Properties
Use computed properties for derived/calculated values. Avoid side effects.

```swift
var usagePercentage: Double {
    guard totalCount > 0 else { return 0 }
    return Double(usedCount) / Double(totalCount) * 100
}
```

#### 9. Structs vs Classes
- Prefer `struct` for models and data
- Use `class` for shared state/ViewModels with `@Published`

```swift
// Model - use struct
struct ModelRemain: Codable, Identifiable { ... }

// ViewModel - use class for shared state
@MainActor
class UsageViewModel: ObservableObject { ... }
```

#### 10. Codable Models
- Use explicit `CodingKeys` for snake_case JSON
- Mark as `Codable, Identifiable` for SwiftUI lists

```swift
struct ModelRemain: Codable, Identifiable {
    let startTime: Int64
    let modelName: String
    
    enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case modelName = "model_name"
    }
    
    var id: String { modelName }
}
```

---

## Key Patterns in This Project

### Singleton Pattern
Used for services that need shared state:

```swift
class MiniMaxAPIService {
    static let shared = MiniMaxAPIService()
    private init() {}
}

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
}
```

### Auto-Refresh Pattern
Timer-based periodic updates with async Task wrapper:

```swift
func startAutoRefresh(interval: TimeInterval = 30) {
    timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
        Task { @MainActor [weak self] in
            await self?.fetchUsage()
        }
    }
}
```

### Data Persistence
UserDefaults for simple key-value and Codable data:

```swift
// Simple string
UserDefaults.standard.set(key, forKey: "minimax_api_key")

// Codable array
let data = try JSONEncoder().encode(snapshots)
UserDefaults.standard.set(data, forKey: "minimax_usage_snapshots")
```

---

## Color Coding Convention

Usage percentage determines the color scheme throughout the app:

| Usage % | Color | Meaning |
|---------|-------|---------|
| 0-70% | `.accentColor` / `.green` | Healthy |
| 70-90% | `.orange` | Warning |
| 90%+ | `.red` | Critical |

Implementation pattern:

```swift
private var statusColor: Color {
    if usagePercentage > 90 {
        return .red
    } else if usagePercentage > 70 {
        return .orange
    } else {
        return .green  // or .accentColor
    }
}
```

---

## Data Flow

```
┌─────────────────────┐
│   ContentView       │  SwiftUI Views
│   (DashboardView,   │
│    UsageView,       │
│    HistoryView)     │
└─────────┬───────────┘
          │ @ObservedObject
          ▼
┌─────────────────────┐
│  UsageViewModel     │  Business Logic
│  - fetchUsage()     │  - State Management
│  - startAutoRefresh │  - Data Persistence
│  - saveSnapshot()   │
└─────────┬───────────┘
          │ calls
          ▼
┌─────────────────────┐     ┌─────────────────────┐
│ MiniMaxAPIService   │────▶│ MiniMax API         │
│ (singleton)         │     │ (api.minimax.io)    │
└─────────────────────┘     └─────────────────────┘
          │
          │ on success
          ▼
┌─────────────────────┐
│ NotificationManager │  Push Notifications
│ (singleton)         │  - Warning: 85%+ used
│                     │  - Critical: 95%+ used
└─────────────────────┘
```

---

## UserDefaults Keys

| Key | Type | Purpose |
|-----|------|---------|
| `minimax_api_key` | `String` | User's API key |
| `minimax_usage_snapshots` | `Data` (JSON encoded) | Historical usage data (max 10,000 entries) |

---

## Common Operations

### Adding a New API Endpoint
1. Add method to `MiniMaxAPIService.swift`
2. Add response model in `CodingPlanModels.swift`
3. Call from `UsageViewModel`

### Adding a New View
1. Create struct in `ContentView.swift` (or new file for large views)
2. Use MVVM: create computed properties in ViewModel if needed
3. Inject ViewModel via `@ObservedObject`

### Adding a New Tab
1. Add case to `ContentView.Tab` enum
2. Add icon in `tabIcon(for:)` method
3. Add case in `mainContent` switch
4. Create the view component

### Modifying Notification Thresholds
Edit in `NotificationManager.swift`:

```swift
private let warningThreshold: Double = 10.0    // Alert at 90% usage
private let criticalThreshold: Double = 5.0   // Alert at 95% usage
```

### Modifying Auto-Refresh Interval
Default is 30 seconds. Modify calls to `startAutoRefresh()`:

```swift
viewModel.startAutoRefresh(interval: 60)  // 60 seconds
```

---

## Testing

### Unit Tests
- Location: `minimax-usage-checkerTests/`
- Framework: Swift Testing (`@Test` macro, `#expect`)
- Import: `import Testing` and `@testable import minimax_usage_checker`

```swift
import Testing
@testable import minimax_usage_checker

struct minimax_usage_checkerTests {
    @Test func example() async throws {
        #expect(true)
    }
}
```

### UI Tests
- Location: `minimax-usage-checkerUITests/`
- Framework: XCTest
- Pattern: Standard XCUITest pattern with `XCUIApplication()`

```swift
import XCTest

final class minimax_usage_checkerUITests: XCTestCase {
    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }
}
```

---

## External Dependencies

None - this project uses only Apple frameworks:

| Framework | Purpose |
|-----------|---------|
| SwiftUI | UI |
| Charts | Data visualization (bar charts) |
| UserNotifications | Local push notifications |
| Foundation | Networking, JSON, UserDefaults |
| Combine | ObservableObject publishing |

---

## API Reference

### Endpoint
```
GET https://api.minimax.io/v1/api/openplatform/coding_plan/remains
Authorization: Bearer {api_key}
Content-Type: application/json
```

### Response Structure
```swift
struct CodingPlanResponse: Codable {
    let modelRemains: [ModelRemain]
    let baseResp: BaseResp
}

struct ModelRemain: Codable, Identifiable {
    let startTime: Int64                      // Window start (Unix ms)
    let endTime: Int64                        // Window end (Unix ms)
    let remainsTime: Int64                    // Remaining time (ms)
    let currentIntervalTotalCount: Int        // Total prompts in window
    let currentIntervalRemainingCount: Int    // Remaining prompts
    let modelName: String                     // Model identifier
}

struct BaseResp: Codable {
    let statusCode: Int                       // 0 = success
    let statusMsg: String
}
```

---

## Gotchas

1. **App Sandbox**: The app uses App Sandbox with network client access. If network calls fail, check entitlements.

2. **Timestamps**: API returns timestamps in milliseconds (Int64). Divide by 1000 for `Date(timeIntervalSince1970:)`.

3. **Notification Deduplication**: `NotificationManager` tracks sent alerts per model+window to avoid spam. Call `clearAlerts()` if you need to reset.

4. **Snapshot Limit**: Max 10,000 snapshots stored. Oldest are pruned automatically.

5. **MainActor**: ViewModels must be `@MainActor` since they update `@Published` properties from async contexts.

6. **Timer in MainActor**: When using `Timer.scheduledTimer` inside a `@MainActor` class, wrap async calls in `Task { @MainActor ... }`.

## Active Technologies
- Swift 5.9+ + SwiftUI (native), Charts framework, Combine, UserNotifications (001-world-class-ui-ux)
- UserDefaults (API key, snapshots) - no changes needed (001-world-class-ui-ux)
- Swift 5.9+ + SwiftUI, Charts, UserNotifications, Foundation, Combine (all native Apple frameworks) (002-usage-alerts)
- UserDefaults for settings and alert history (002-usage-alerts)
- Swift 5.9+ (Xcode 15.0+) + SwiftUI, Charts (native Apple frameworks), Combine, UserNotifications (003-compact-refined-ui)
- UserDefaults (API key, snapshots, alert settings) (003-compact-refined-ui)

## Recent Changes
- 001-world-class-ui-ux: Added Swift 5.9+ + SwiftUI (native), Charts framework, Combine, UserNotifications

---

## 001-World-Class-UI-UX Implementation Status

**Note**: All design tokens reduced for compact UI (Feature 003-compact-refined-ui). See "Design Tokens (Compact UI - 003)" section below.

### Design System

**Implemented** (`DesignSystem/` folder):
| File | Status | Notes |
|------|--------|-------|
| `DesignTokens.swift` | ✅ Complete | All colors, spacing, typography, shadows implemented |
| `Animations.swift` | ✅ Complete | All animation extensions implemented |
| `UsageStatus.swift` | ✅ Complete | Safe/Warning/Critical states |
| `EmptyStateType.swift` | ✅ Complete | Enum for empty states |
| `ErrorStateType.swift` | ✅ Complete | Enum for error states |

**Color Assets** (`Assets.xcassets/Colors/`):
| Color | Purpose |
|-------|---------|
| `UsageSafe`, `UsageWarning`, `UsageCritical` | Usage status indicators |
| `SurfacePrimary`, `SurfaceSecondary`, `SurfaceTertiary`, `SurfaceHover` | Background surfaces |
| `BorderSubtle`, `BorderEmphasis`, `BorderFocus` | Border/stroke colors |
| `TextPrimary`, `TextSecondary`, `TextTertiary`, `TextDisabled` | Text hierarchy |
| `AccentPrimary`, `AccentSecondary` | Accent colors |

### Components

**Implemented** (`Components/` folder) - All 11 spec components:
| Component | Status |
|-----------|--------|
| CircularProgressView | ✅ |
| LinearProgressView | ✅ |
| StatCard | ✅ |
| ModelCard | ✅ |
| EmptyStateView | ✅ |
| ErrorStateView | ✅ |
| LoadingStateView | ✅ |
| TabBar | ✅ |
| TimeRangePicker | ✅ |
| TimelineChart | ✅ |
| TooltipView | ✅ |

**Additional Components** (not in original spec but implemented):
- PrimaryUsageIndicator
- ModelStatusList
- ModelStatusRow
- StatsOverview

### Views

**Implemented** (`Views/` folder):
| View | Status |
|------|--------|
| DashboardView | ✅ |
| UsageView | ✅ |
| HistoryView | ✅ |
| MainView | ✅ |
| OnboardingView | ✅ |

### Project Structure

```
minimax-usage-checker/
├── DesignSystem/           # Design tokens & types
│   ├── DesignTokens.swift   # ✅ Complete - colors, spacing, typography, shadows
│   ├── Animations.swift     # ✅
│   ├── UsageStatus.swift    # ✅
│   ├── EmptyStateType.swift # ✅
│   └── ErrorStateType.swift # ✅
├── Components/             # Reusable UI components
│   ├── CircularProgressView.swift
│   ├── LinearProgressView.swift
│   ├── ModelCard.swift
│   ├── ModelStatusList.swift
│   ├── ModelStatusRow.swift
│   ├── PrimaryUsageIndicator.swift
│   ├── StatCard.swift
│   ├── StatsOverview.swift
│   ├── TabBar.swift
│   ├── TimeRangePicker.swift
│   ├── TimelineChart.swift
│   ├── EmptyStateView.swift
│   ├── ErrorStateView.swift
│   ├── LoadingStateView.swift
│   └── TooltipView.swift
├── Views/                  # Main app views
│   ├── DashboardView.swift
│   ├── UsageView.swift
│   ├── HistoryView.swift
│   ├── MainView.swift
│   └── OnboardingView.swift
├── Assets.xcassets/
│   └── Colors/             # ✅ All design tokens colors implemented
└── ...
```

### CI/CD

GitHub Actions workflow (`.github/workflows/build.yml`):
- Runs on push to `master` branch
- Uses `macos-latest` runner
- Builds with `CODE_SIGNING_ALLOWED=NO`
- Uploads build artifact for 7 days

### LSP/Tooling Note

The project uses `PBXFileSystemSynchronizedRootGroup` for automatic file inclusion. SourceKit may show temporary errors until Xcode fully indexes the new files. Run a clean build to resolve.

---

## 002-Usage-Alerts Implementation Status

### Overview
Configurable usage alert thresholds with per-model settings, alert history, and snooze functionality.

### Feature Components

**Core Models** (`minimax-usage-checker/` folder):
| File | Purpose |
|------|---------|
| `AlertModels.swift` | AlertType, SnoozeDuration, ValidationError enums |
| `AlertSettings.swift` | AlertSettings struct with Codable |
| `ModelAlertSettings.swift` | Per-model threshold override struct |
| `AlertHistoryEntry.swift` | Alert history record struct |
| `AlertSettingsManager.swift` | Settings persistence manager (singleton) |
| `AlertHistoryManager.swift` | History storage manager (singleton) |

**UI Components** (`Views/` folder):
| File | Purpose |
|------|---------|
| `AlertSettingsView.swift` | Alert settings UI |
| `AlertHistoryView.swift` | Alert history UI |
| `AlertsMainView.swift` | Combined alerts view with tabs |
| `CustomMessageView.swift` | Custom message template editor |
| `PerModelSettingsView.swift` | Per-model threshold overrides |
| `SnoozeOptionsView.swift` | Snooze duration picker |

### User Stories

| US | Priority | Description | Status |
|----|----------|-------------|--------|
| US1 | P1 | Configure Alert Thresholds | ✅ Complete |
| US2 | P2 | Per-Model Configuration | ✅ Complete |
| US3 | P3 | Alert History | ✅ Complete |
| US4 | P3 | Snooze Alerts | ✅ Complete |
| US5 | P4 | Custom Alert Messages | ✅ Complete |

### Key Implementation Details

- **AlertSettingsManager**: `@MainActor` singleton with `@Published` settings
- **AlertHistoryManager**: Singleton managing history array with auto-prune at 100 entries
- **NotificationManager**: Extended to use configurable thresholds from AlertSettingsManager
- **Snooze durations**: 15min, 1hr, 4hr, 24hr
- **Validation**: Warning must exceed Critical threshold

### UserDefaults Keys

| Key | Type | Purpose |
|-----|------|---------|
| `alert_settings` | `Data` (JSON encoded) | Alert configuration |
| `alert_history` | `Data` (JSON encoded) | Alert history (max 100 entries) |

### Custom Message Variables

- `{model}` - Model name
- `{remaining}` - Remaining tokens count
- `{percent}` - Usage percentage

---

## Design Tokens (Compact UI - 003)

All design tokens reduced by 25-50% for compact UI (Feature 003-compact-refined-ui). See `specs/003-compact-refined-ui/migration-guide.md` for complete migration details.

### Typography Scale (8 levels, 10pt-24pt)

| Token | Size | Usage |
|-------|------|-------|
| displayLarge | 24pt | Large headings (onboarding, empty states) |
| displayMedium | 18pt | Medium headings |
| headingLarge | 16pt | Section headers |
| headingMedium | 14pt | Subsection headers |
| bodyLarge | 13pt | Primary body text |
| bodyMedium | 12pt | Secondary body text |
| caption | 11pt | Captions, labels (minimum readable size) |
| captionSmall | 10pt | Small captions, tertiary text |

### Spacing Scale (6 levels, 4pt-32pt)

| Token | Size | Usage |
|-------|------|-------|
| xs | 4pt | Minimal spacing (inside buttons, list separators) |
| sm | 6pt | Tight spacing (list items, stack spacing) |
| md | 8pt | Standard spacing (card padding, section gaps) |
| lg | 14pt | Comfortable spacing (between sections) |
| xl | 24pt | Large spacing (view padding, major sections) |
| xxl | 32pt | Extra large spacing (top-level containers) |

### Border Radius (5 levels, 4pt-full)

| Token | Size | Usage |
|-------|------|-------|
| sm | 4pt | Buttons, small elements |
| md | 6pt | Cards, inputs |
| lg | 10pt | Large cards, containers |
| xl | 16pt | Unused (reserved) |
| full | 9999pt | Circular elements (progress rings, status dots) |

### Shadows (4 levels, 2pt-12pt blur)

| Token | Blur | Y-Offset | Opacity | Usage |
|-------|------|----------|---------|-------|
| elevation1 | 2pt | 1pt | 0.02 | Subtle depth (cards) |
| elevation2 | 6pt | 2pt | 0.04 | Moderate depth (tooltips) |
| elevation3 | 12pt | 4pt | 0.06 | Strong depth (modals) |
| focus | 8pt | 0pt | 0.15 | Keyboard focus rings |

### Accessibility

**Touch Targets**: Minimum 44pt enforced on:
- TabBar (line 65: `.frame(minHeight: 44)`)
- ModelCard expand button (line 44: `.frame(minHeight: 44)`)

**Font Size**: Minimum 11pt (caption token), 10pt for tertiary text only

**Dynamic Type**: Capped at `.medium ... .large` range (ContentView.swift line 50)

**Color Contrast**: All text meets WCAG AA standards (TextPrimary/TextSecondary on SurfacePrimary/SurfaceSecondary backgrounds)

**Reduce Motion**: All animations respect system preference via `@Environment(\.accessibilityReduceMotion)`

### Window Constraints

- **Minimum size**: 300x400pt (ContentView.swift line 29)
- **Default size**: 400x600pt (minimax_usage_checkerApp.swift line 17)
- **Compact goal**: Display 5+ model cards at 800x600 without scrolling

