# Migration Guide: Compact Refined UI (Feature 003)

## Overview

Feature 003 introduces a compact design system with reduced design tokens to improve information density while maintaining readability and accessibility. This guide helps developers update existing components or create new ones following the new design language.

---

## Design Token Changes

### Typography (25% reduction)

| Token | Before | After | Change |
|-------|--------|-------|--------|
| `displayLarge` | 32pt | 24pt | -25% |
| `displayMedium` | 24pt | 18pt | -25% |
| `headingLarge` | 20pt | 16pt | -20% |
| `headingMedium` | 17pt | 14pt | -18% |
| `bodyLarge` | 16pt | 13pt | -19% |
| `bodyMedium` | 15pt | 12pt | -20% |
| `caption` | 13pt | 11pt | -15% |
| `captionSmall` | 11pt | 10pt | -9% |

**Typography scale ratio**: 2.4:1 reduced to 2.2:1 (displayLarge:captionSmall) for tighter visual hierarchy.

### Spacing (37% reduction)

| Token | Before | After | Change |
|-------|--------|-------|--------|
| `xs` | 6pt | 4pt | -33% |
| `sm` | 10pt | 6pt | -40% |
| `md` | 12pt | 8pt | -33% |
| `lg` | 20pt | 14pt | -30% |
| `xl` | 32pt | 24pt | -25% |
| `xxl` | 48pt | 32pt | -33% |

**Spacing range**: 42pt total span reduced to 28pt for compact layouts.

### Border Radius (33% reduction)

| Token | Before | After | Change |
|-------|--------|-------|--------|
| `sm` | 6pt | 4pt | -33% |
| `md` | 8pt | 6pt | -25% |
| `lg` | 12pt | 10pt | -17% |
| `xl` | 16pt | 16pt | 0% (unused) |
| `full` | 9999pt | 9999pt | 0% |

### Shadows (50% reduction)

| Token | Before | After | Change |
|-------|--------|-------|--------|
| `elevation1` | radius 4pt, y:2 | radius 2pt, y:1 | -50% |
| `elevation2` | radius 12pt, y:4 | radius 6pt, y:2 | -50% |
| `elevation3` | radius 24pt, y:8 | radius 12pt, y:4 | -50% |
| `focus` | radius 16pt | radius 8pt | -50% |

---

## Component Updates

### Before: Old Design

```swift
VStack(spacing: 16) {
    Text("Title")
        .font(.system(size: 20))
        .padding(16)
    
    CircularProgressView(
        percentage: 75,
        lineWidth: 8,
        diameter: 120
    )
}
.padding(16)
.background(
    RoundedRectangle(cornerRadius: 12)
        .fill(Color.gray.opacity(0.1))
)
.shadow(radius: 12, y: 4)
```

### After: Compact Design

```swift
VStack(spacing: DesignTokens.Spacing.lg) {  // 14pt
    Text("Title")
        .font(DesignTokens.Typography.headingLarge)  // 16pt
        .padding(DesignTokens.Spacing.md)  // 8pt
    
    CircularProgressView(
        percentage: 75,
        lineWidth: 6,  // Reduced from 8
        diameter: 80   // Reduced from 120
    )
}
.padding(DesignTokens.Spacing.md)  // 8pt
.background(
    RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)  // 10pt
        .fill(DesignTokens.Colors.surfaceSecondary)
)
.shadow(
    color: Color.black.opacity(0.04),
    radius: 6,  // Reduced from 12
    y: 2        // Reduced from 4
)
```

---

## Touch Targets & Accessibility

All interactive components must maintain **44pt minimum touch targets** even with reduced visual size:

```swift
Button(action: { /* action */ }) {
    HStack(spacing: DesignTokens.Spacing.sm) {  // 6pt
        Image(systemName: "gear")
            .font(DesignTokens.Typography.bodyMedium)  // 12pt
        Text("Settings")
            .font(DesignTokens.Typography.bodyMedium)
    }
    .padding(.vertical, 6)   // Visual padding (tight)
    .padding(.horizontal, 12)
}
.frame(minHeight: 44)  // Accessibility touch target
.contentShape(Rectangle())
.buttonStyle(.plain)
```

**Key principle**: Visual height can be less than 44pt, but the interactive frame must be ≥44pt for accessibility compliance.

---

## Animations

Use new animation helpers that respect reduce motion:

```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

// For layout changes, expand/collapse
.animation(.appSpring(reduceMotion: reduceMotion), value: isExpanded)

// For hover states, subtle transitions
.animation(.appSubtle(reduceMotion: reduceMotion), value: isHovered)
```

**Animation timing**: Spring response 0.35s→0.2s (43% faster for snappier UI).

**Animation extensions** (defined in `DesignSystem/Animations.swift`):

```swift
extension Animation {
    static func appSpring(reduceMotion: Bool) -> Animation {
        reduceMotion ? .none : .spring(response: 0.2, dampingFraction: 0.8)
    }
    
    static func appSubtle(reduceMotion: Bool) -> Animation {
        reduceMotion ? .none : .easeInOut(duration: 0.2)
    }
}
```

---

## Window Constraints

Ensure layouts work at minimum 300×400 window size:

```swift
ContentView()
    .frame(minWidth: 300, minHeight: 400)  // Minimum size
    .dynamicTypeSize(.medium ... .large)   // Cap text scaling
```

**Window configuration** (in `minimax_usage_checkerApp.swift`):

```swift
WindowGroup {
    ContentView()
}
.windowStyle(.hiddenTitleBar)
.defaultSize(width: 400, height: 600)
```

---

## Common Patterns

### Status Indicators

Always use `UsageStatus.color` for consistent color coding:

```swift
let status = UsageStatus(percentage: model.usagePercentage)

Circle()
    .fill(status.color)  // Green <70%, Orange 70-90%, Red >90%
    .frame(width: 8, height: 8)
```

### Expandable Sections

Use ModelCard pattern with `@State isExpanded`:

```swift
@State private var isExpanded: Bool = false
@Environment(\.accessibilityReduceMotion) var reduceMotion

var body: some View {
    VStack(alignment: .leading, spacing: 0) {
        // Summary always visible
        Button(action: { isExpanded.toggle() }) {
            HStack {
                Text("Model Name")
                Spacer()
                Image(systemName: "chevron.right")
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
            }
            .padding(.vertical, DesignTokens.Spacing.sm)
            .padding(.horizontal, DesignTokens.Spacing.md)
            .frame(minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        
        if isExpanded {
            // Details with smooth transition
            DetailView()
                .padding(DesignTokens.Spacing.md)
                .transition(.opacity.combined(with: .move(edge: .top)))
        }
    }
    .animation(.appSpring(reduceMotion: reduceMotion), value: isExpanded)
}
```

### Loading States

Use LoadingStateView with shimmer animation (no explicit spinner sizing needed):

```swift
if viewModel.isLoading {
    LoadingStateView()
} else {
    ContentView()
}
```

### Empty States

Use EmptyStateView with EmptyStateType enum:

```swift
if viewModel.modelRemains.isEmpty {
    EmptyStateView(type: .noData)
} else {
    ContentView()
}
```

---

## Testing Checklist

Before submitting code using compact design:

- [ ] Component respects DesignTokens (no hardcoded padding/fonts)
- [ ] Touch targets ≥44pt for interactive elements (use `.frame(minHeight: 44)`)
- [ ] Layout works at 300×400 minimum window size
- [ ] Animations respect reduce motion preference (`@Environment(\.accessibilityReduceMotion)`)
- [ ] Status colors use `UsageStatus.color` enum
- [ ] Font weights follow hierarchy (semibold/medium for primary, regular for secondary)
- [ ] Minimum font size ≥11pt for readability
- [ ] Spacing uses DesignTokens.Spacing (not hardcoded values)
- [ ] Border radius uses DesignTokens.Radius (not hardcoded values)
- [ ] Shadows use DesignTokens shadow constants (not arbitrary blur/offset)

---

## Breaking Changes

### Component API Changes

**CircularProgressView**:
- Default `diameter`: 120→80 (-33%)
- Default `lineWidth`: 8→6 (-25%)

**LinearProgressView**:
- Default `height`: 8→6 (-25%)

**ModelCard**:
- Now includes expand/collapse functionality (`@State isExpanded`)
- Touch target: `minHeight: 44` maintained despite visual padding reduction

**TabBar**:
- Visual height: 44pt→40pt
- Touch target: `minHeight: 44` maintained

### Migration Steps

1. **Replace hardcoded values**: Search for `.padding(16)`, `.font(.system(size: 20))`, etc. Replace with DesignTokens.
2. **Update component sizes**: CircularProgressView, LinearProgressView now use smaller defaults.
3. **Add touch targets**: Interactive components need `.frame(minHeight: 44)` if not already present.
4. **Test at 300×400**: Verify layout doesn't break at minimum window size.
5. **Test reduce motion**: Enable System Preferences → Accessibility → Reduce Motion and verify animations disabled.

---

## Examples

### Before/After: Dashboard Stats Card

**Before**:
```swift
VStack(spacing: 12) {
    Image(systemName: "chart.bar")
        .font(.system(size: 20))
    Text("1,234")
        .font(.system(size: 24))
    Text("Used")
        .font(.system(size: 13))
}
.padding(16)
```

**After**:
```swift
VStack(spacing: DesignTokens.Spacing.sm) {  // 6pt
    Image(systemName: "chart.bar")
        .font(.system(size: 16))  // Icon size intentional (Phase 6)
    Text("1,234")
        .font(DesignTokens.Typography.displayMedium)  // 18pt
    Text("Used")
        .font(DesignTokens.Typography.caption)  // 11pt
}
.padding(DesignTokens.Spacing.md)  // 8pt
```

### Before/After: Model Status Row

**Before**:
```swift
HStack(spacing: 12) {
    Circle()
        .fill(color)
        .frame(width: 10, height: 10)
    Text(model.name)
        .font(.system(size: 15))
    Spacer()
    Text(model.remaining)
        .font(.system(size: 13))
}
.padding(12)
```

**After**:
```swift
HStack(spacing: DesignTokens.Spacing.md) {  // 8pt
    Circle()
        .fill(status.color)  // UsageStatus.color
        .frame(width: 8, height: 8)  // Component-specific size
    Text(model.name)
        .font(DesignTokens.Typography.bodyMedium)  // 12pt
    Spacer()
    Text(model.remaining)
        .font(DesignTokens.Typography.caption)  // 11pt
        .foregroundStyle(status.color)
}
.padding(DesignTokens.Spacing.md)  // 8pt
```

---

## Resources

- **Spec**: `specs/003-compact-refined-ui/spec.md`
- **Tasks**: `specs/003-compact-refined-ui/tasks.md`
- **Quickstart**: `specs/003-compact-refined-ui/quickstart.md`
- **Design Tokens**: `minimax-usage-checker/DesignSystem/DesignTokens.swift`
- **Animations**: `minimax-usage-checker/DesignSystem/Animations.swift`
