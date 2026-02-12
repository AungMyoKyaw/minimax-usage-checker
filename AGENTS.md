# AGENTS.md - MiniMax Usage Checker

This file provides guidelines for AI agents operating in this repository.

## Project Overview

- **Project Type**: Native macOS application (Swift/SwiftUI)
- **Minimum macOS**: 12.0 (Monterey)
- **Swift Version**: 5.9+
- **Xcode Version**: 15.0+
- **Architecture**: MVVM (Model-View-ViewModel)
- **Testing Framework**: Swift Testing (built into Xcode)

## Build & Run Commands

### Using Xcode (Recommended)

```bash
# Open project in Xcode
open minimax-usage-checker.xcodeproj

# Build the project (Cmd + B in Xcode)
# Product → Build

# Run the app (Cmd + R in Xcode)
```

### Using xcodebuild (Command Line)

```bash
# Build for macOS
xcodebuild -project minimax-usage-checker.xcodeproj -scheme minimax-usage-checker -configuration Debug build

# Build for release
xcodebuild -project minimax-usage-checker.xcodeproj -scheme minimax-usage-checker -configuration Release build
```

### Running Tests

```bash
# Run all tests
xcodebuild test -project minimax-usage-checker.xcodeproj -scheme minimax-usage-checker

# Run a single test class
xcodebuild test -project minimax-usage-checker.xcodeproj -scheme minimax-usage-checker -only-testing:minimax_usage_checkerTests/minimax_usage_checkerTests

# Run a specific test (Swift Testing)
xcodebuild test -project minimax-usage-checker.xcodeproj -scheme minimax-usage-checker -only-testing:minimax_usage_checkerTests/minimax_usage_checkerTests/example
```

### Running UI Tests

```bash
# Run UI tests
xcodebuild test -project minimax-usage-checker.xcodeproj -scheme minimax-usage-checker -destination 'platform=macOS'
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

### File Structure

```
minimax-usage-checker/
├── minimax_usage_checkerApp.swift    # App entry point (@main)
├── ContentView.swift                 # Main UI views
├── UsageViewModel.swift              # ViewModel (business logic)
├── MiniMaxAPIService.swift           # API layer
├── CodingPlanModels.swift            # Data models
├── NotificationManager.swift         # Notifications
└── Assets.xcassets/                  # Resources
```

### Swift Language Guidelines

#### 1. Imports
- Group imports: Foundation → System frameworks → Third-party
- Use explicit imports for clarity

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
- Use custom error enums conforming to `LocalizedError`
- Provide meaningful `errorDescription`

```swift
enum APIError: LocalizedError {
    case invalidURL
    case noAPIKey
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noAPIKey:
            return "No API key configured"
        }
    }
}
```

#### 5. Async/Await
- Use `async/await` for asynchronous operations
- Use `@MainActor` for UI-related code
- Wrap async calls in `Task` when needed

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
- Mark with `@MainActor` and `@MainActor` inheritance
- Use `@Published` for observable state
- Use `@StateObject` for creation, `@ObservedObject` for injection

```swift
@MainActor
class UsageViewModel: ObservableObject {
    @Published var isLoading = false
}
```

**Views**:
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
- Use computed properties for derived/calculated values
- Avoid side effects in computed properties

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
    
    enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
    }
    
    var id: String { modelName }
}
```

---

## Key Patterns in This Project

### Singleton Pattern
```swift
class MiniMaxAPIService {
    static let shared = MiniMaxAPIService()
    private init() {}
}
```

### Notification Manager
```swift
class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
}
```

### Auto-Refresh Pattern
```swift
func startAutoRefresh(interval: TimeInterval = 30) {
    timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
        Task { @MainActor [weak self] in
            await self?.fetchUsage()
        }
    }
}
```

---

## Common Operations

### Adding a New API Endpoint
1. Add method to `MiniMaxAPIService.swift`
2. Add model in `CodingPlanModels.swift`
3. Call from `UsageViewModel`

### Adding a New View
1. Create struct in `ContentView.swift` or new file
2. Use MVVM: create computed properties in ViewModel
3. Inject ViewModel via `@ObservedObject`

### Modifying Notification Thresholds
Edit in `NotificationManager.swift`:
```swift
private let warningThreshold: Double = 10.0    // 90% usage
private let criticalThreshold: Double = 5.0   // 95% usage
```

---

## Testing Notes

- Tests are in `minimax-usage-checkerTests/`
- UI tests in `minimax-usage-checkerUITests/`
- Use Swift Testing framework (`@Test` macro)
- No external testing libraries currently in use

---

## External Dependencies

None - this project uses only Apple frameworks:
- SwiftUI (UI)
- Charts (Data visualization)
- UserNotifications (Alerts)
- Foundation (Networking, JSON)
