# Component Specifications

**Date**: 2026-02-14
**Feature**: 001-world-class-ui-ux

---

## Overview

This document specifies each reusable component in the design system, including its interface, behavior, and accessibility requirements.

---

## Progress Components

### CircularProgressView

Circular progress indicator for time-based metrics.

**Interface**:
```swift
struct CircularProgressView: View {
    let progress: Double        // 0.0 to 1.0
    let status: UsageStatus     // Determines color
    let size: CGSize            // Default: 120x120
    let lineWidth: CGFloat      // Default: 8
    let showPercentage: Bool    // Default: true
}
```

**Behavior**:
- Animates smoothly from previous value to new value
- Color transitions based on status (safe → warning → critical)
- Percentage text updates with number animation

**Accessibility**:
- `accessibilityValue`: "X percent used"
- `accessibilityLabel`: "Usage progress indicator"

---

### LinearProgressView

Linear progress bar for count-based metrics.

**Interface**:
```swift
struct LinearProgressView: View {
    let progress: Double        // 0.0 to 1.0
    let status: UsageStatus     // Determines color
    let height: CGFloat         // Default: 8
    let showLabel: Bool         // Default: false
    let usedCount: Int?         // Optional label
    let remainingCount: Int?    // Optional label
}
```

**Behavior**:
- Spring animation on progress change
- Gradient fill from solid to 60% opacity
- Corner radius matches height/2

**Accessibility**:
- `accessibilityValue`: "X of Y used"
- `accessibilityLabel`: "Progress bar"

---

## Card Components

### StatCard

Dashboard statistic card with icon, value, and label.

**Interface**:
```swift
struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String            // SF Symbol name
    let status: UsageStatus     // Determines accent color
    let trend: TrendDirection?  // Optional: .up, .down, .neutral
}
```

**Behavior**:
- Hover: subtle scale (1.02) and shadow increase
- Click: optional expansion (if details provided)
- Value animates on change

**Visual**:
- Background: `surfacePrimary`
- Border: `borderSubtle` with status color at 20% opacity
- Corner radius: `lg` (16px)
- Padding: `lg` (24px)

**Accessibility**:
- Combined into single accessibility element
- `accessibilityLabel`: "{title}: {value} {subtitle}"

---

### ModelCard

Detailed model usage card for Usage tab.

**Interface**:
```swift
struct ModelCard: View {
    let model: ModelRemain
    let isExpanded: Bool
    let onToggle: () -> Void
}
```

**Behavior**:
- Collapsed: Shows name, progress bar, remaining time
- Expanded: Shows full details including window timeline
- Spring animation on expand/collapse
- Press feedback on tap

**Visual**:
- Background: `surfacePrimary`
- Border: Status color at 15% opacity
- Shadow: `shadow-md` when expanded
- Corner radius: `xl` (20px)

**Accessibility**:
- `accessibilityLabel`: "{modelName}, {remainingTime} remaining, {percentage}% used"
- `accessibilityHint`: "Double tap for details"

---

## State Components

### EmptyStateView

Displays when expected content is absent.

**Interface**:
```swift
struct EmptyStateView: View {
    let type: EmptyStateType
    let action: (() -> Void)?   // Optional action button
}
```

**Behavior**:
- Gentle entrance animation (fade + scale)
- Icon has subtle pulse animation
- Action button has pressed state

**Visual**:
- Icon: 100x100 with gradient circle background
- Title: `headingMedium`
- Message: `bodyMedium` in `textSecondary`
- Generous vertical padding

**Accessibility**:
- Icon ignored (decorative)
- Title and message combined
- Action button accessible

---

### ErrorStateView

Displays when something goes wrong.

**Interface**:
```swift
struct ErrorStateView: View {
    let type: ErrorStateType
    let onRetry: () -> Void
}
```

**Behavior**:
- No animation (static to avoid irritation)
- Single clear action button
- Optional detail disclosure for technical info

**Visual**:
- Icon: Warning triangle in status color
- Title: `headingMedium`
- Message: `bodyMedium`
- Action: Primary button style

**Accessibility**:
- Full content accessible
- Action clearly labeled

---

### LoadingStateView

Displays during data loading.

**Interface**:
```swift
struct LoadingStateView: View {
    let message: String?        // Optional loading message
}
```

**Behavior**:
- Skeleton screens that match content layout
- Shimmer animation on skeleton elements
- Respects layout stability (no content shift)

**Visual**:
- Skeleton elements: `surfaceSecondary`
- Shimmer: `surfaceHover` moving left to right
- Maintains card structure

---

## Navigation Components

### TabBar

Custom tab navigation for main views.

**Interface**:
```swift
struct TabBar: View {
    @Binding var selectedTab: TabIdentifier
    let isLoading: Bool
    let onRefresh: () -> Void
}
```

**Behavior**:
- Selected tab has background highlight
- Smooth transition between tabs
- Refresh button shows spinner when loading
- Keyboard navigation support

**Visual**:
- Height: 44px
- Tab padding: 20px horizontal, 10px vertical
- Selected background: `accentPrimary` at 15%
- Corner radius: `sm` (8px)

**Accessibility**:
- Each tab is accessibility element
- `accessibilityLabel`: "{tabName} tab"
- `accessibilityValue`: "Selected" / "Not selected"
- `accessibilityHint`: "Selects {tabName} view"

---

### TimeRangePicker

Segmented control for history time range.

**Interface**:
```swift
struct TimeRangePicker: View {
    @Binding var selectedRange: TimeRange
}
```

**Behavior**:
- Selected segment has filled background
- Smooth selection animation
- Haptic feedback on selection

**Visual**:
- Height: 36px
- Segment padding: 16px horizontal, 8px vertical
- Selected: `accentPrimary` background, white text
- Unselected: `surfaceSecondary`, `textSecondary`

---

## Data Components

### TimelineChart

Chart visualization for usage history.

**Interface**:
```swift
struct TimelineChart: View {
    let data: [DailyUsage]
    let timeRange: TimeRange
    let onBarTap: ((DailyUsage) -> Void)?
}
```

**Behavior**:
- Bars animate in with stagger
- Hover shows tooltip with exact values
- Tap selects bar for detail view
- Responsive to window size

**Visual**:
- Bar width: Responsive to data density
- Bar color: Gradient `accentPrimary` to 60%
- Corner radius: 4px on bars
- Grid lines: `borderSubtle`

**Accessibility**:
- Chart described as data table
- Each bar accessible individually
- `accessibilityValue`: "{date}: {count} prompts used"

---

### TooltipView

Hover tooltip for data points.

**Interface**:
```swift
struct TooltipView: View {
    let title: String
    let value: String
    let detail: String?
    let position: TooltipPosition  // .above, .below, .auto
}
```

**Behavior**:
- Appears 100ms after hover
- Positions to avoid screen edges
- Disappears immediately on hover end

**Visual**:
- Background: `surfacePrimary` with `shadow-lg`
- Border: `borderEmphasis`
- Corner radius: `md` (12px)
- Padding: `sm` (8px)

---

## Component Hierarchy

```
ContentView
├── OnboardingView (no API key)
│   ├── BrandHeader
│   ├── SecureInputField
│   └── PrimaryButton
│
├── TabBar
│
├── DashboardView
│   ├── PrimaryUsageIndicator (CircularProgressView)
│   ├── StatsOverview (4x StatCard)
│   ├── UsageChart (TimelineChart)
│   └── ModelStatusList (ModelStatusRow)
│
├── UsageView
│   └── ModelCard (repeated, expandable)
│
└── HistoryView
    ├── TimeRangePicker
    ├── TimelineChart
    └── HistoryList
        └── HistoryRow
```

---

## Component Checklist

> **Note**: This checklist reflects the current implementation status as of 2026-02-14.

|| Component | Implemented | Tested | Accessible |
||-----------|-------------|--------|------------|
|| CircularProgressView | ✅ | ⬜ | ⬜ |
|| LinearProgressView | ✅ | ⬜ | ⬜ |
|| StatCard | ✅ | ⬜ | ⬜ |
|| ModelCard | ✅ | ⬜ | ⬜ |
|| EmptyStateView | ✅ | ⬜ | ⬜ |
|| ErrorStateView | ✅ | ⬜ | ⬜ |
|| LoadingStateView | ✅ | ⬜ | ⬜ |
|| TabBar | ✅ | ⬜ | ⬜ |
|| TimeRangePicker | ✅ | ⬜ | ⬜ |
|| TimelineChart | ✅ | ⬜ | ⬜ |
|| TooltipView | ✅ | ⬜ | ⬜ |

### Additional Components Implemented

These components were added beyond the original spec:

| Component | Status |
|-----------|--------|
| PrimaryUsageIndicator | ✅ |
| ModelStatusList | ✅ |
| ModelStatusRow | ✅ |
| StatsOverview | ✅ |
