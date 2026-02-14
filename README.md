# MiniMax Usage Checker

A native macOS application for monitoring your MiniMax AI API usage in real-time. Track prompts, remaining credits, and usage trends with a beautiful dashboard interface.

![macOS](https://img.shields.io/badge/macOS-12.0+-blue?style=flat-square)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange?style=flat-square)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Charts-green?style=flat-square)
[![Build macOS App](https://github.com/aungmyokyaw/minimax-usage-checker/actions/workflows/build.yml/badge.svg)](https://github.com/aungmyokyaw/minimax-usage-checker/actions/workflows/build.yml)

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
├── minimax-usage-checker/
│   ├── minimax_usage_checkerApp.swift    # App entry point
│   ├── ContentView.swift                  # Root view with navigation
│   ├── UsageViewModel.swift               # Business logic & state management
│   ├── MiniMaxAPIService.swift            # API communication layer
│   ├── CodingPlanModels.swift            # Data models
│   ├── NotificationManager.swift          # Local notifications
│   ├── DesignSystem/                      # Design system tokens & types
│   │   ├── DesignTokens.swift             # Colors, spacing, typography
│   │   ├── Animations.swift               # Animation extensions
│   │   ├── UsageStatus.swift              # Safe/Warning/Critical states
│   │   ├── EmptyStateType.swift           # Empty state enums
│   │   └── ErrorStateType.swift           # Error state enums
│   ├── Views/                            # Main app views
│   │   ├── MainView.swift                 # Tab container
│   │   ├── DashboardView.swift            # Dashboard overview
│   │   ├── UsageView.swift                # Per-model usage details
│   │   ├── HistoryView.swift              # Historical data
│   │   └── OnboardingView.swift           # API key entry
│   ├── Components/                        # Reusable UI components
│   │   ├── CircularProgressView.swift      # Circular progress indicator
│   │   ├── LinearProgressView.swift       # Linear progress bar
│   │   ├── ModelCard.swift                # Model detail card
│   │   ├── ModelStatusList.swift          # List of model statuses
│   │   ├── ModelStatusRow.swift           # Single model status row
│   │   ├── PrimaryUsageIndicator.swift    # Main usage display
│   │   ├── StatCard.swift                 # Statistics card
│   │   ├── StatsOverview.swift            # Stats overview panel
│   │   ├── TabBar.swift                   # Tab navigation bar
│   │   ├── TimeRangePicker.swift           # Time range selector
│   │   ├── TimelineChart.swift             # Usage timeline chart
│   │   ├── EmptyStateView.swift            # Empty state display
│   │   ├── ErrorStateView.swift            # Error state display
│   │   ├── LoadingStateView.swift         # Loading spinner
│   │   └── TooltipView.swift               # Tooltip component
│   └── Assets.xcassets/                   # App icons & colors
├── minimax-usage-checkerTests/             # Unit tests
└── minimax-usage-checkerUITests/          # UI tests
```

### Architecture Pattern: MVVM

- **Model**: `CodingPlanModels.swift` - Data structures for API responses
- **View**: SwiftUI views in `Views/` and `Components/` folders
- **ViewModel**: `UsageViewModel.swift` - Business logic, state management, data transformation

### Design System

The app implements a comprehensive compact design system optimized for information density while maintaining readability and accessibility:

#### Compact Design Tokens (Feature 003)

**Typography Scale** (25% reduction from original):
- `displayLarge`: 24pt (large headings, icons)
- `displayMedium`: 18pt (medium headings)
- `headingLarge`: 16pt (section headers)
- `headingMedium`: 14pt (subsection headers)
- `bodyLarge`: 13pt (emphasized body text)
- `bodyMedium`: 12pt (standard body text)
- `caption`: 11pt (labels, secondary text)
- `captionSmall`: 10pt (tertiary text, metadata)

**Spacing Scale** (37% reduction):
- `xs`: 4pt (minimal spacing, button padding)
- `sm`: 6pt (tight grouping)
- `md`: 8pt (default spacing)
- `lg`: 14pt (generous spacing)
- `xl`: 24pt (section separators)
- `xxl`: 32pt (major sections)

**Border Radius** (33% reduction):
- `sm`: 4pt (small elements, pills)
- `md`: 6pt (buttons, inputs)
- `lg`: 10pt (cards, panels)
- `xl`: 16pt (large containers, unused)
- `full`: 9999pt (circles, fully rounded)

**Shadows** (50% reduction):
- `elevation1`: 2pt blur, 1pt offset, 0.02 opacity (subtle depth)
- `elevation2`: 6pt blur, 2pt offset, 0.04 opacity (moderate depth)
- `elevation3`: 12pt blur, 4pt offset, 0.06 opacity (strong emphasis)
- `focus`: 8pt blur, 0.15 opacity (focus states)

**Color System**:

| Category | Components |
|----------|------------|
| Colors | Surface (primary/secondary/tertiary/hover), Border (subtle/emphasis/focus), Text (primary/secondary/tertiary/disabled), Accent (primary/secondary), Usage (safe/warning/critical) |

**Accessibility**:
- Minimum touch targets: 44pt (maintained despite visual size reductions)
- Minimum font size: 11pt (caption) for readability
- Color contrast: WCAG AA compliant status indicators
- Reduce motion support: All animations respect `@Environment(\.accessibilityReduceMotion)`
- Dynamic type: Capped at `.medium` to `.large` range for layout stability

**Window Constraints**:
- Minimum size: 300×400
- Default size: 400×600
- Responsive layouts adapt to window resize

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
    let startTime: Int64              // Window start (Unix ms)
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
private let criticalThreshold: Double = 5.0  // 95% usage
```

## Requirements

- **Minimum macOS**: 12.0 (Monterey)
- **Frameworks**: SwiftUI, Charts, UserNotifications, Combine

## Building & Running

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
```

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Author

Aung Myo Kyaw
