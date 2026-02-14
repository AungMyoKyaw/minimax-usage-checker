# Component Sizing API Contract

**Version**: 1.0.0-compact  
**Type**: Internal SwiftUI Component API  
**Scope**: Component-specific size relationships for 003-compact-refined-ui

## Overview

Defines default sizing properties and proportional relationships for high-impact components affected by design token refinement. Components use these contracts to ensure consistent compact proportions.

---

## API: `CircularProgressView`

### Purpose
Circular progress indicator for primary usage display

### Properties

```swift
struct CircularProgressView: View {
    var diameter: CGFloat = 80        // Circle diameter
    var lineWidth: CGFloat = 6         // Progress ring thickness
    var percentage: Double             // 0-100
    var status: UsageStatus            // Safe/Warning/Critical
}
```

### Compact Specification

| Property | Value (pt) | Relationship |
|----------|------------|--------------|
| `diameter` | 80 | Default size (reduced from 120pt) |
| `lineWidth` | 6 | diameter / 13.3 ratio |
| Inner content area | 68 | diameter - (2 × lineWidth) |

### Constraints
- `lineWidth` should maintain ~13:1 ratio with `diameter`
- Inner area must accommodate `displayLarge` (24pt) text with padding
- Minimum diameter: 60pt (for readability)

### Usage Example
```swift
CircularProgressView(
    diameter: 80,
    lineWidth: 6,
    percentage: 85.3,
    status: .warning
)
```

---

## API: `LinearProgressView`

### Purpose
Horizontal progress bar for compact inline usage display

### Properties

```swift
struct LinearProgressView: View {
    var percentage: Double           // 0-100
    var height: CGFloat = 6          // Bar height
    var cornerRadius: CGFloat = 3    // Half of height for pill shape
    var status: UsageStatus          // Safe/Warning/Critical
}
```

### Compact Specification

| Property | Value (pt) | Relationship |
|----------|------------|--------------|
| `height` | 6 | Default (reduced from 8pt) |
| `cornerRadius` | 3 | height / 2 (pill shape) |

### Constraints
- `cornerRadius = height / 2` for consistent pill appearance
- Minimum height: 4pt (still visible)

---

## API: `StatCard`

### Purpose
Statistics card with icon, label, and value

### Properties

```swift
struct StatCard: View {
    var title: String
    var value: String
    var icon: String                  // SF Symbol name
    var padding: CGFloat = 10         // Internal padding
    var iconSize: CGFloat = 16        // Icon dimension
}
```

### Compact Specification

| Property | Value (pt) | Relationship |
|----------|------------|--------------|
| `padding` | 10 | `DesignTokens.Spacing.md` |
| `iconSize` | 16 | ~1.2× adjacent text size (13pt bodyLarge) |

### Constraints
- `padding` must use `Spacing.md` (10pt)
- `iconSize` ≈ adjacent font size + 3-4pt
- Minimum card height: 44pt (touch target)

### Usage Example
```swift
StatCard(
    title: "Total",
    value: "5,000",
    icon: "number.circle",
    padding: DesignTokens.Spacing.md,
    iconSize: 16
)
```

---

## API: `ModelCard`

### Purpose
Collapsible card displaying model usage details

### Properties

```swift
struct ModelCard: View {
    var model: ModelRemain
    var isExpanded: Bool
    var verticalPadding: CGFloat = 8     // Top/bottom padding
    var horizontalPadding: CGFloat = 10  // Left/right padding
    
    var collapsedHeight: CGFloat {       // Computed
        return 44  // Minimum touch target
    }
}
```

### Compact Specification

| Property | Value (pt) | Relationship |
|----------|------------|--------------|
| `verticalPadding` | 8 | `DesignTokens.Spacing.sm + 2` |
| `horizontalPadding` | 10 | `DesignTokens.Spacing.md` |
| `collapsedHeight` | 44 | Accessibility minimum |
| Content area height | 28 | 44 - (2 × 8) |

### Constraints
- `collapsedHeight` ≥ 44pt (accessibility)
- Content area must fit:
  - Single line `headingMedium` (14pt) for model name
  - Single line `bodyMedium` (12pt) for usage metrics
  - With 2pt gap between lines → 14 + 2 + 12 = 28pt ✓

### Layout Breakdown
```
┌─────────────────────────────────────┐ ┐
│ [verticalPadding: 8pt]              │ │
│   Model Name (14pt headingMedium)   │ │ 44pt
│   1,234/5,000 (12pt bodyMedium)     │ │ total
│ [verticalPadding: 8pt]              │ │
└─────────────────────────────────────┘ ┘
```

---

## API: `TabBar`

### Purpose
Bottom tab navigation bar

### Properties

```swift
struct TabBar: View {
    var selectedTab: Binding<Tab>
    var totalHeight: CGFloat = 40       // Bar height
    var iconSize: CGFloat = 16          // Tab icon size
    var labelFont: Font = .caption      // 11pt
}
```

### Compact Specification

| Property | Value (pt) | Calculation |
|----------|------------|-------------|
| `totalHeight` | 40 | Sum of components below |
| `iconSize` | 16 | Reduced from 20pt |
| Top padding | 6 | Spacing above icon |
| Icon height | 16 | Icon size |
| Icon-label gap | 2 | Tight spacing |
| Label height | 11 | Caption font (11pt) |
| Bottom padding | 5 | Spacing below label |
| **Total** | **40** | 6 + 16 + 2 + 11 + 5 |

### Constraints
- `totalHeight` ≤ 40pt (spec requirement FR-009)
- Effective touch target ≥ 44pt (use `.contentShape()` to expand hit area)
- `iconSize` should be 1.4× `labelFont.size` (16pt icon, 11pt label)

### Touch Target Strategy
```swift
.contentShape(Rectangle())
.frame(minHeight: 44)  // Expand hit target beyond visual 40pt
```

---

## API: `TimelineChart`

### Purpose
Historical usage chart using Swift Charts framework

### Properties

```swift
struct TimelineChart: View {
    var snapshots: [SnapshotData]
    var axisLabelFont: Font = .caption      // 11pt
    var legendFont: Font = .captionSmall    // 10pt
    var chartHeight: CGFloat = 180
}
```

### Compact Specification

| Property | Value | Notes |
|----------|-------|-------|
| `axisLabelFont` | `.caption` (11pt) | X/Y axis labels |
| `legendFont` | `.captionSmall` (10pt) | Chart legend |
| `chartHeight` | 180 | Reduced from ~220pt |

### Constraints
- `axisLabelFont` ≥ 11pt (minimum readability)
- `legendFont` ≥ 10pt (absolute minimum)
- Chart must render readable on Retina (2x) displays at these sizes

---

## API: `ModelStatusRow`

### Purpose
Single row in model list (used in `UsageView`, `DashboardView`)

### Properties

```swift
struct ModelStatusRow: View {
    var model: ModelRemain
    var rowHeight: CGFloat = 44         // Minimum touch target
    var contentPadding: CGFloat = 8     // Internal spacing
}
```

### Compact Specification

| Property | Value (pt) | Notes |
|----------|------------|-------|
| `rowHeight` | 44 | Accessibility minimum |
| `contentPadding` | 8 | Vertical internal spacing |
| Horizontal padding | 10 | `DesignTokens.Spacing.md` |

### Constraints
- `rowHeight` ≥ 44pt (FR-010, FR-016)
- Content area: 44 - (2 × 8) = 28pt (same as `ModelCard`)

---

## API: `PrimaryUsageIndicator`

### Purpose
Dashboard hero metric with large circular progress

### Properties

```swift
struct PrimaryUsageIndicator: View {
    var totalUsed: Int
    var totalCount: Int
    var usagePercentage: Double
    var progressDiameter: CGFloat = 80      // Circular progress size
}
```

### Compact Specification

| Property | Value (pt) | Notes |
|----------|------------|-------|
| `progressDiameter` | 80 | Uses `CircularProgressView(diameter: 80)` |
| Below-progress spacing | 14 | `DesignTokens.Spacing.lg` |
| Label font | `bodyMedium` (12pt) | Subdued secondary text |

---

## Cross-Component Relationships

### Icon-to-Text Sizing
All components follow consistent icon sizing:

| Text Size | Icon Size | Ratio |
|-----------|-----------|-------|
| 10pt (captionSmall) | 14pt | 1.4× |
| 11pt (caption) | 14pt | 1.3× |
| 12pt (bodyMedium) | 16pt | 1.3× |
| 13pt (bodyLarge) | 16pt | 1.2× |
| 14pt (headingMedium) | 18pt | 1.3× |

**Rule**: `iconSize ≈ textSize + 3pt` (approximately 1.2-1.4× multiplier)

### Touch Target Matrix

| Component | Visual Height | Touch Target | Strategy |
|-----------|---------------|--------------|----------|
| ModelCard | 44pt | 44pt | Visual = Touch |
| ModelStatusRow | 44pt | 44pt | Visual = Touch |
| TabBar | 40pt | 44pt | Expanded via `.contentShape()` |
| StatCard | Variable | ≥44pt | Enforce minimum frame |

---

## Animation Timing

All components use unified animation duration:

```swift
.animation(.spring(response: 0.2, dampingFraction: 0.75), value: someState)
```

| Property | Value | Notes |
|----------|-------|-------|
| Duration | 0.2s | Reduced from 0.3s (FR-017) |
| Spring response | 0.2 | Snappy feel for compact UI |
| Damping fraction | 0.75 | Smooth settle (unchanged) |

---

## Validation Checklist

For each component:
- [ ] References `DesignTokens` for typography, spacing, radius
- [ ] No hardcoded size values outside this contract
- [ ] Interactive elements maintain ≥44pt touch targets
- [ ] Icon sizes proportional to adjacent text (1.2-1.4×)
- [ ] Animations use 0.2s duration
- [ ] Minimum font size ≥10pt (captionSmall)

---

## Notes

- Components may accept custom size parameters but should default to values in this contract
- Size parameters should be expressed as `CGFloat` (not raw numeric literals)
- Use `DesignTokens` enum as single source of truth for shared values (spacing, typography)
- Component-specific sizing (e.g., `CircularProgressView.diameter`) lives in component defaults, not `DesignTokens`
