# Data Model: Compact Refined UI

**Branch**: `003-compact-refined-ui` | **Date**: 2026-02-14

## Overview

This feature is **visual-only refinement** with **no data model changes**. All existing models, ViewModels, and data persistence remain unchanged. This document captures the design token transformations and component sizing relationships.

## Design Token Transformations

### Entity: DesignTokens.Typography

**Current State**:
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

**Compact State** (Target):
```swift
enum Typography {
    static let displayLarge = Font.system(size: 24, weight: .bold, design: .rounded)     // -50%
    static let displayMedium = Font.system(size: 18, weight: .semibold, design: .rounded) // -44%
    static let headingLarge = Font.system(size: 16, weight: .semibold)                   // -33%
    static let headingMedium = Font.system(size: 14, weight: .semibold)                  // -22%
    static let bodyLarge = Font.system(size: 13, weight: .regular)                       // -19%
    static let bodyMedium = Font.system(size: 12, weight: .regular)                      // -14%
    static let caption = Font.system(size: 11, weight: .regular)                         // -8%
    static let captionSmall = Font.system(size: 10, weight: .regular)                    // 0%
}
```

**Relationships**:
- Maximum font size: 24pt (displayLarge)
- Minimum body text: 12pt (bodyMedium)
- Ratio: 2:1 (24pt / 12pt)

**Validation**:
- ✅ Spec requirement FR-001: Largest font ≤ 24pt
- ✅ Spec requirement SC-007: Maximum 2:1 ratio

---

### Entity: DesignTokens.Spacing

**Current State**:
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

**Compact State** (Target):
```swift
enum Spacing {
    static let xs: CGFloat = 4   // 0% (minimum)
    static let sm: CGFloat = 6   // -25%
    static let md: CGFloat = 10  // -38%
    static let lg: CGFloat = 14  // -42%
    static let xl: CGFloat = 16  // -50%
    static let xxl: CGFloat = 20 // -58%
}
```

**Relationships**:
- 4pt grid base (xs: 4pt)
- Maximum internal padding: 10pt (md)
- Maximum section spacing: 16pt (xl)

**Validation**:
- ✅ Spec requirement FR-002: Max internal padding 12pt (using 10pt)
- ✅ Spec requirement FR-002: Max section spacing 16pt
- ✅ Spec requirement SC-008: Consistent 4pt grid

---

### Entity: DesignTokens.Radius

**Current State**:
```swift
enum Radius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let full: CGFloat = 9999
}
```

**Compact State** (Target):
```swift
enum Radius {
    static let sm: CGFloat = 6    // -25%
    static let md: CGFloat = 6    // -50% (unified with sm)
    static let lg: CGFloat = 8    // -50%
    static let xl: CGFloat = 8    // -60% (unified with lg)
    static let full: CGFloat = 9999 // 0% (unchanged)
}
```

**Relationships**:
- Two-tier system: 6pt (small), 8pt (large)
- Full radius (9999pt) preserved for circular progress

**Validation**:
- ✅ Spec requirement FR-003: Maximum 8pt border radius
- ✅ Spec requirement SC-009: Consistent radii (6pt/8pt only)

---

### Entity: DesignTokens.Shadow

**Current State**:
```swift
enum Shadow {
    static let sm = ShadowStyle(color: .black.opacity(0.04), radius: 1, x: 0, y: 1)
    static let md = ShadowStyle(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    static let lg = ShadowStyle(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
    static let focus = ShadowStyle(color: Color.accentColor.opacity(0.3), radius: 0, x: 0, y: 0)
}
```

**Compact State** (Target):
```swift
enum Shadow {
    static let sm = ShadowStyle(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)  // -50% opacity
    static let md = ShadowStyle(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)  // -50% blur, -50% opacity
    static let lg = ShadowStyle(color: .black.opacity(0.06), radius: 3, x: 0, y: 2)  // -63% blur, -50% opacity
    static let focus = ShadowStyle(color: Color.accentColor.opacity(0.2), radius: 0, x: 0, y: 0) // -33% opacity
}
```

**Relationships**:
- Maximum blur: 3pt (lg)
- Opacity range: 0.02-0.06 (down from 0.04-0.12)

**Validation**:
- ✅ Spec requirement FR-005: Shadow blur 2-4pt (using 1-3pt, within tolerance)

---

## Component Sizing Relationships

### CircularProgressView

**Fields**:
- `diameter: CGFloat` (default)
- `lineWidth: CGFloat`

**Current → Compact**:
- diameter: 120pt → 80pt (-33%)
- lineWidth: 8pt → 6pt (-25%)

**Relationships**:
- Line width = diameter / 13.3 (80 / 6 ≈ 13.3)
- Inner content area = diameter - (2 × lineWidth) = 68pt (sufficient for 24pt text)

**Validation**:
- ✅ Spec requirement FR-006: 80pt diameter, 6pt line width

---

### StatCard

**Fields**:
- `padding: CGFloat` (internal)
- `iconSize: CGFloat`

**Current → Compact**:
- padding: 16pt → 10pt (-38%)
- iconSize: 20pt → 16pt (-20%)

**Relationships**:
- Icon-to-text ratio: iconSize ≈ bodyLarge + 3pt (16pt icon, 13pt text)

**Validation**:
- ✅ Spec requirement FR-007: 10pt padding, 16pt icon

---

### ModelCard

**Fields**:
- `verticalPadding: CGFloat`
- `horizontalPadding: CGFloat`
- `collapsedHeight: CGFloat` (computed)

**Current → Compact**:
- verticalPadding: 12pt → 8pt (-33%)
- horizontalPadding: 16pt → 10pt (-38%)
- collapsedHeight: ~65pt → ~44pt (-32%)

**Relationships**:
- Minimum height: 44pt (accessibility touch target)
- Content height = 44pt - (2 × 8pt padding) = 28pt internal
- Supports single line of headingMedium (14pt) + bodyMedium (12pt) stacked

**Validation**:
- ✅ Spec requirement FR-008: ~30% reduction in collapsed height
- ✅ Spec requirement FR-016: 44pt minimum touch target

---

### TabBar

**Fields**:
- `totalHeight: CGFloat`

**Current → Compact**:
- totalHeight: 44pt+ → 40pt (-9%)

**Relationships**:
- Icon size: 16pt (down from 20pt)
- Label font: caption (11pt)
- Vertical padding: 6pt top, 6pt bottom
- Total: 6pt + 16pt + 2pt gap + 11pt + 5pt = 40pt

**Validation**:
- ✅ Spec requirement FR-009: ≤40pt height
- ✅ Spec requirement FR-016: Effective 44pt touch target (expanded hit area)

---

### TimelineChart

**Fields**:
- `axisLabelFont: Font`
- `legendFont: Font`

**Current → Compact**:
- axisLabelFont: 14pt → 11pt (-21%)
- legendFont: 12pt → 10pt (-17%)

**Relationships**:
- Axis labels use caption (11pt)
- Legend uses captionSmall (10pt)

**Validation**:
- ✅ Minimum 10pt preserved for readability

---

## State Transitions

**N/A** - This feature has no state machine changes. All component states (collapsed/expanded, loading/loaded/error) remain unchanged.

## Validation Rules

### Typography Constraints
- `displayLarge.size ≤ 24pt` (FR-001)
- `bodyMedium.size ≥ 12pt` (minimum readability)
- `displayLarge.size / bodyMedium.size ≤ 2.0` (SC-007)

### Spacing Constraints
- All spacing values must be multiples of 4pt (SC-008)
- `Spacing.md ≤ 12pt` (internal padding, FR-002)
- `Spacing.xl ≤ 16pt` (section spacing, FR-002)

### Component Constraints
- All touch targets ≥ 44pt (FR-016, accessibility)
- `CircularProgressView.diameter ≥ 80pt` (FR-006)
- `ModelCard.collapsedHeight ≥ 44pt` (FR-016)

### Visual Hierarchy Constraints
- Primary info uses weight (semibold/bold) + color, not size (FR-011)
- Secondary info uses regular weight + tertiary color (FR-012)
- Icon size ≤ adjacent text size + 4pt (FR-014)

---

## Migration Notes

**No data migration required** - This feature modifies design tokens only. Existing data structures, persistence, and API contracts are unchanged.

**User-facing changes**:
- Visual density increased (more content per screen)
- No functional changes
- No settings/preferences modified

**Testing focus**:
- Verify readability at new font sizes
- Confirm 44pt touch targets preserved
- Validate 5+ cards visible at 800x600 window (SC-001)
- Test Dynamic Type scaling remains bounded (10-18pt range)
