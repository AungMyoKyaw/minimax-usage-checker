# MiniMax Usage Checker

A native macOS application for monitoring your MiniMax AI API usage in real-time. Track prompts, remaining credits, and usage trends with a beautiful dashboard interface.

![macOS](https://img.shields.io/badge/macOS-12.0+-blue?style=flat-square)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange?style=flat-square)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Charts-green?style=flat-square)

## Features

### Dashboard
- **Stats Overview**: View total used prompts, remaining prompts, average usage percentage, and active model count at a glance
- **Usage Trend Chart**: Visual bar chart showing daily usage patterns
- **Model Status**: Quick view of remaining time for each AI model

### Usage View
- **Per-Model Details**: Detailed breakdown of each model's usage with progress bars
- **Visual Progress**: Color-coded progress indicators (green < 70%, orange 70-90%, red > 90%)
- **Real-Time Updates**: Auto-refresh every 30 seconds

### History View
- **Time Range Filtering**: Filter by Today, Week, Month, or All time
- **Usage Snapshots**: Historical record of all usage data points
- **Grouped by Date**: Automatically organized by day for easy browsing

### Notifications
- **Warning Alerts**: Notified when usage exceeds 85% (15% remaining)
- **Critical Alerts**: Notified when usage exceeds 95% (5% remaining)
- **Smart Deduplication**: Alerts sent once per model window to avoid spam

## Getting Started

### Prerequisites

- macOS 12.0 (Monterey) or later
- Xcode 15.0+
- A MiniMax API key

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/aungmyokyaw/minimax-usage-checker.git
   ```

2. Open the project in Xcode:
   ```bash
   open minimax-usage-checker.xcodeproj
   ```

3. Build and run (Cmd + R)

### First-Time Setup

1. Launch the application
2. Enter your MiniMax API key in the login screen
3. Click "Get Started" to begin monitoring

Your API key is stored securely in local storage and never leaves your device.

## Project Architecture

```
minimax-usage-checker/
├── minimax_usage_checkerApp.swift    # App entry point
├── ContentView.swift                 # Main UI with tab navigation
├── UsageViewModel.swift              # Business logic & state management
├── MiniMaxAPIService.swift          # API communication layer
├── CodingPlanModels.swift            # Data models
├── NotificationManager.swift        # Local notifications
└── Assets.xcassets/                 # App icons & colors
```

### Architecture Pattern: MVVM

- **Model**: `CodingPlanModels.swift` - Data structures for API responses
- **View**: `ContentView.swift` - SwiftUI views (Dashboard, Usage, History)
- **ViewModel**: `UsageViewModel.swift` - Business logic, state management, data transformation

### Key Components

| Component | Responsibility |
|-----------|----------------|
| `MiniMaxAPIService` | Handles API calls to MiniMax backend |
| `UsageViewModel` | Manages app state, auto-refresh, data persistence |
| `NotificationManager` | Monitors usage thresholds and sends alerts |
| `SnapshotData` | Historical usage tracking with local storage |

## API Integration

The app connects to MiniMax's coding plan API to fetch usage data:

- **Endpoint**: `https://api.minimax.io/v1/api/openplatform/coding_plan/remains`
- **Authentication**: Bearer token (API key)
- **Refresh Interval**: 30 seconds (configurable)

### Response Model

```swift
struct CodingPlanResponse: Codable {
    let modelRemains: [ModelRemain]  // Per-model usage data
    let baseResp: BaseResp           // API status
}

struct ModelRemain: Codable, Identifiable {
    let startTime: Int64             // Window start (Unix ms)
    let endTime: Int64                // Window end (Unix ms)
    let remainsTime: Int64            // Remaining time (ms)
    let currentIntervalTotalCount:    // Total prompts in window
    let currentIntervalRemainingCount // Remaining prompts
    let modelName: String             // Model identifier
}
```

## Data Storage

- **API Key**: Stored in `UserDefaults` with key `minimax_api_key`
- **Usage Snapshots**: Persisted in `UserDefaults` with key `minimax_usage_snapshots`
- **Max Snapshots**: 10,000 entries (oldest automatically pruned)

## Configuration

### Auto-Refresh Interval

Default: 30 seconds. Modify in `UsageViewModel.swift`:

```swift
func startAutoRefresh(interval: TimeInterval = 30) {
    // ...
}
```

### Notification Thresholds

Configure in `NotificationManager.swift`:

```swift
private let warningThreshold: Double = 10.0   // 90% usage
private let criticalThreshold: Double = 5.0    // 95% usage
```

## Requirements

- **Minimum macOS**: 12.0 (Monterey)
- **Frameworks**: SwiftUI, Charts, UserNotifications

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Author

Aung Myo Kyaw
