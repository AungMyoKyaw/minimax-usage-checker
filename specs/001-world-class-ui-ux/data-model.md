# Data Model: World-Class UI/UX Redesign

**Date**: 2026-02-14
**Feature**: 001-world-class-ui-ux

---

## Overview

This document defines the UI-specific data models and state structures needed for the redesign. The existing data models (`ModelRemain`, `CodingPlanResponse`, etc.) remain unchanged.

---

## Design Tokens

### Color Tokens

```swift
enum AppColor {
    // Status Colors (semantic)
    static let usageSafe = Color("UsageSafe")      // Green - <70%
    static let usageWarning = Color("UsageWarning") // Orange - 70-90%
    static let usageCritical = Color("UsageCritical") // Red - >90%
    
    // Surface Colors
    static let surfacePrimary = Color("SurfacePrimary")   // Card backgrounds
    static let surfaceSecondary = Color("SurfaceSecondary") // Nested containers
    static let surfaceTertiary = Color("SurfaceTertiary")  // Window background
    
    // Border Colors
    static let borderSubtle = Color("BorderSubtle")
    static let borderEmphasis = Color("BorderEmphasis")
    
    // Text Colors
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let textTertiary = Color(.tertiaryLabelColor)
}
```

### Spacing Tokens

```swift
enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}
```

### Typography Tokens

```swift
enum Typography {
    static let displayLarge = Font.system(size: 48, weight: .bold, design: .rounded)
    static let displayMedium = Font.system(size: 32, weight: .bold, design: .rounded)
    static let headingLarge = Font.system(size: 24, weight: .semibold)
    static let headingMedium = Font.system(size: 18, weight: .semibold)
    static let bodyLarge = Font.system(size: 16, weight: .regular)
    static let bodyMedium = Font.system(size: 14, weight: .regular)
    static let caption = Font.system(size: 12, weight: .regular)
    static let captionSmall = Font.system(size: 10, weight: .regular)
}
```

### Corner Radius Tokens

```swift
enum CornerRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let full: CGFloat = .infinity
}
```

---

## UI State Models

### UsageStatus

Represents the visual status of usage for color-coded display.

```swift
enum UsageStatus {
    case safe      // <70% usage
    case warning   // 70-90% usage
    case critical  // >90% usage
    
    init(percentage: Double) {
        if percentage > 90 { self = .critical }
        else if percentage > 70 { self = .warning }
        else { self = .safe }
    }
    
    var color: Color {
        switch self {
        case .safe: return AppColor.usageSafe
        case .warning: return AppColor.usageWarning
        case .critical: return AppColor.usageCritical
        }
    }
}
```

### TabIdentifier

Identifies the current main view.

```swift
enum TabIdentifier: String, CaseIterable {
    case dashboard
    case usage
    case history
    
    var label: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .usage: return "Usage"
        case .history: return "History"
        }
    }
    
    var icon: String {
        switch self {
        case .dashboard: return "chart.bar.fill"
        case .usage: return "cpu"
        case .history: return "clock.arrow.circlepath"
        }
    }
}
```

### TimeRange (Existing - Documented)

```swift
enum TimeRange: String, CaseIterable {
    case today = "Today"
    case week = "Week"
    case month = "Month"
    case all = "All"
}
```

### ModelState

Represents the expanded/collapsed state of a model card.

```swift
struct ModelState: Identifiable {
    let id: String  // Model name
    var isExpanded: Bool = false
    var isHighlighted: Bool = false
}
```

---

## View State Extensions

### UsageViewModel Extensions

New @Published properties to add to existing ViewModel:

```swift
// UI State
@Published var selectedTab: TabIdentifier = .dashboard
@Published var expandedModels: [String: Bool] = [:]
@Published var isLoadingInitially: Bool = true
@Published var isRefreshing: Bool = false
@Published var errorMessage: String?
@Published var showError: Bool = false

// Computed Properties
var overallStatus: UsageStatus {
    let maxPercentage = modelRemains.map(\.usagePercentage).max() ?? 0
    return UsageStatus(percentage: maxPercentage)
}

var mostUrgentModel: ModelRemain? {
    modelRemains.max(by: { $0.usagePercentage < $1.usagePercentage })
}
```

---

## Empty State Models

### EmptyStateType

```swift
enum EmptyStateType {
    case noAPIKey
    case noHistory
    case noModels
    case firstTimeUser
    
    var title: String {
        switch self {
        case .noAPIKey: return "Welcome to MiniMax Usage"
        case .noHistory: return "No history yet"
        case .noModels: return "No models available"
        case .firstTimeUser: return "Let's get started"
        }
    }
    
    var message: String {
        switch self {
        case .noAPIKey: return "Enter your API key to start tracking your usage"
        case .noHistory: return "Your usage history will appear here as data is collected"
        case .noModels: return "No model usage data is currently available"
        case .firstTimeUser: return "Track your AI usage in real-time with beautiful analytics"
        }
    }
    
    var icon: String {
        switch self {
        case .noAPIKey: return "brain.head.profile"
        case .noHistory: return "clock.arrow.circlepath"
        case .noModels: return "cpu"
        case .firstTimeUser: return "sparkles"
        }
    }
}
```

### ErrorStateType

```swift
enum ErrorStateType {
    case networkError
    case invalidAPIKey
    case rateLimited
    case serviceUnavailable
    case unknown(String)
    
    var title: String {
        switch self {
        case .networkError: return "Connection Issue"
        case .invalidAPIKey: return "Invalid API Key"
        case .rateLimited: return "Rate Limited"
        case .serviceUnavailable: return "Service Unavailable"
        case .unknown: return "Something went wrong"
        }
    }
    
    var message: String {
        switch self {
        case .networkError: return "Please check your internet connection and try again"
        case .invalidAPIKey: return "Your API key may have changed. Please update it."
        case .rateLimited: return "You've made too many requests. Please wait a moment."
        case .serviceUnavailable: return "MiniMax services are temporarily unavailable."
        case .unknown(let detail): return detail
        }
    }
    
    var actionLabel: String {
        switch self {
        case .networkError, .serviceUnavailable, .unknown: return "Try Again"
        case .invalidAPIKey: return "Update API Key"
        case .rateLimited: return "Wait & Retry"
        }
    }
}
```

---

## Animation State

### AnimationConfiguration

```swift
struct AnimationConfiguration {
    var duration: Double
    var curve: Animation
    
    static let transition = AnimationConfiguration(
        duration: 0.3,
        curve: .easeInOut(duration: 0.3)
    )
    
    static let spring = AnimationConfiguration(
        duration: 0.35,
        curve: .spring(response: 0.35, dampingFraction: 0.75)
    )
    
    static let subtle = AnimationConfiguration(
        duration: 0.2,
        curve: .easeOut(duration: 0.2)
    )
    
    static let value = AnimationConfiguration(
        duration: 0.25,
        curve: .easeInOut(duration: 0.25)
    )
}
```

---

## Relationships

```
┌─────────────────────────────────────────────────────────────┐
│                     UsageViewModel                          │
│  ┌─────────────────┐  ┌─────────────────┐                  │
│  │ modelRemains    │  │ UI State        │                  │
│  │ [ModelRemain]   │  │ - selectedTab   │                  │
│  │                 │  │ - expandedModels│                  │
│  │ Uses →          │  │ - isLoading     │                  │
│  └────────┬────────┘  └─────────────────┘                  │
│           │                                                  │
│           ▼                                                  │
│  ┌─────────────────┐                                        │
│  │ UsageStatus     │  ← Derived from usagePercentage       │
│  │ - safe          │                                        │
│  │ - warning       │                                        │
│  │ - critical      │                                        │
│  └─────────────────┘                                        │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                     Design Tokens                           │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────┐  │
│  │ Colors    │ │ Spacing   │ │ Typography│ │ Animation │  │
│  │ - Status  │ │ - 8px grid│ │ - Scale   │ │ - Timing  │  │
│  │ - Surface │ │ - Tokens  │ │ - Weights │ │ - Curves  │  │
│  └───────────┘ └───────────┘ └───────────┘ └───────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## Validation Rules

| Entity | Field | Rule |
|--------|-------|------|
| UsageStatus | percentage | 0-100 range, derived |
| ModelState | id | Must match ModelRemain.modelName |
| TimeRange | - | CaseIterable, 4 values max |
| AnimationConfiguration | duration | 0-400ms for perceived instant |
