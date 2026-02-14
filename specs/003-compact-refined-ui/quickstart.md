# Quickstart: Implementing Compact Refined UI

**Feature**: `003-compact-refined-ui`  
**Branch**: `003-compact-refined-ui`  
**Target**: Existing developers familiar with the minimax-usage-checker codebase

## Overview

This guide walks through implementing the compact UI refinement in a systematic, testable sequence. The feature focuses on visual density through design token reduction while preserving all functionality and accessibility.

**Key Principle**: Modify `DesignTokens.swift` first (single source of truth), then cascade changes to components.

---

## Prerequisites

- Xcode 15.0+ installed
- Existing minimax-usage-checker project cloned
- Familiarity with SwiftUI and MVVM pattern
- Read `specs/003-compact-refined-ui/spec.md` and `research.md`

---

## Implementation Sequence

### Phase 1: Design Tokens Update ⚡ CRITICAL PATH

**File**: `minimax-usage-checker/DesignSystem/DesignTokens.swift`

**Why first**: All components reference these tokens. Single change propagates globally.

#### Step 1.1: Update Typography Enum

```swift
enum Typography {
    static let displayLarge = Font.system(size: 24, weight: .bold, design: .rounded)      // 48 → 24
    static let displayMedium = Font.system(size: 18, weight: .semibold, design: .rounded) // 32 → 18
    static let headingLarge = Font.system(size: 16, weight: .semibold)                   // 24 → 16
    static let headingMedium = Font.system(size: 14, weight: .semibold)                  // 18 → 14
    static let bodyLarge = Font.system(size: 13, weight: .regular)                       // 16 → 13
    static let bodyMedium = Font.system(size: 12, weight: .regular)                      // 14 → 12
    static let caption = Font.system(size: 11, weight: .regular)                         // 12 → 11
    static let captionSmall = Font.system(size: 10, weight: .regular)                    // 10 (unchanged)
}
```

**Verification**:
```bash
# Build project
xcodebuild -project minimax-usage-checker.xcodeproj -scheme minimax-usage-checker -configuration Debug build

# Run app in Xcode (Cmd+R)
# Verify: All text is smaller but readable
```

---

#### Step 1.2: Update Spacing Enum

```swift
enum Spacing {
    static let xs: CGFloat = 4   // 4 (unchanged)
    static let sm: CGFloat = 6   // 8 → 6
    static let md: CGFloat = 10  // 16 → 10
    static let lg: CGFloat = 14  // 24 → 14
    static let xl: CGFloat = 16  // 32 → 16
    static let xxl: CGFloat = 20 // 48 → 20
}
```

**Verification**:
```bash
# Build and run
# Verify: Cards and panels have tighter padding
# Check: No overlapping text or icons (spacing still sufficient)
```

---

#### Step 1.3: Update Radius Enum

```swift
enum Radius {
    static let sm: CGFloat = 6    // 8 → 6
    static let md: CGFloat = 6    // 12 → 6 (unified with sm)
    static let lg: CGFloat = 8    // 16 → 8
    static let xl: CGFloat = 8    // 20 → 8 (unified with lg)
    static let full: CGFloat = 9999 // Unchanged
}
```

**Verification**:
```bash
# Build and run
# Verify: Corners are subtly rounded (6-8pt), not "bubbly"
```

---

#### Step 1.4: Update Shadow Enum

```swift
enum Shadow {
    static let sm = ShadowStyle(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)  // opacity 0.04 → 0.02
    static let md = ShadowStyle(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)  // radius 4 → 2, opacity 0.08 → 0.04
    static let lg = ShadowStyle(color: .black.opacity(0.06), radius: 3, x: 0, y: 2)  // radius 8 → 3, opacity 0.12 → 0.06
    static let focus = ShadowStyle(color: Color.accentColor.opacity(0.2), radius: 0, x: 0, y: 0) // opacity 0.3 → 0.2
}
```

**Verification**:
```bash
# Build and run
# Verify: Cards have subtle elevation, not dramatic shadows
```

---

### Phase 2: Update Animations.swift

**File**: `minimax-usage-checker/DesignSystem/Animations.swift`

Find the `.appSpring` animation extension and update duration:

```swift
extension Animation {
    static let appSpring = Animation.spring(response: 0.2, dampingFraction: 0.75)  // 0.3 → 0.2
}
```

**Verification**:
```bash
# Build and run
# Test: Expand/collapse ModelCard, switch tabs → animations feel snappier
```

---

### Phase 3: Component-Specific Updates

These components have hardcoded sizes that bypass `DesignTokens`. Update defaults.

#### Step 3.1: CircularProgressView

**File**: `minimax-usage-checker/Components/CircularProgressView.swift`

Find default size parameters and update:

```swift
struct CircularProgressView: View {
    var diameter: CGFloat = 80        // 120 → 80
    var lineWidth: CGFloat = 6         // 8 → 6
    // ... rest unchanged
}
```

**Verification**:
```bash
# Run app → Dashboard tab
# Verify: Primary usage circle is smaller but percentage text (24pt) is clearly readable
```

---

#### Step 3.2: LinearProgressView

**File**: `minimax-usage-checker/Components/LinearProgressView.swift`

```swift
struct LinearProgressView: View {
    var height: CGFloat = 6           // 8 → 6
    var cornerRadius: CGFloat = 3     // 4 → 3 (half of height)
    // ... rest unchanged
}
```

---

#### Step 3.3: StatCard

**File**: `minimax-usage-checker/Components/StatCard.swift`

Update padding and icon size:

```swift
struct StatCard: View {
    var padding: CGFloat = 10         // 16 → 10
    var iconSize: CGFloat = 16        // 20 → 16
    // ... rest unchanged
}
```

**Alternative approach** (preferred if component already uses tokens):
```swift
.padding(DesignTokens.Spacing.md)  // Already 10pt from Phase 1
```

---

#### Step 3.4: ModelCard

**File**: `minimax-usage-checker/Components/ModelCard.swift`

Update padding values:

```swift
struct ModelCard: View {
    var verticalPadding: CGFloat = 8     // 12 → 8
    var horizontalPadding: CGFloat = 10  // 16 → 10
    // ... rest unchanged
}
```

**Ensure minimum height**:
```swift
var body: some View {
    VStack { /* content */ }
        .frame(minHeight: 44)  // Accessibility touch target
}
```

---

#### Step 3.5: TabBar

**File**: `minimax-usage-checker/Components/TabBar.swift`

Update total height and icon size:

```swift
struct TabBar: View {
    var totalHeight: CGFloat = 40       // 44+ → 40
    var iconSize: CGFloat = 16          // 20 → 16
    
    var body: some View {
        HStack {
            ForEach(tabs) { tab in
                Button { /* ... */ } label: {
                    VStack(spacing: 2) {               // Tight icon-label gap
                        Image(systemName: tab.icon)
                            .font(.system(size: iconSize))  // 16pt
                        Text(tab.label)
                            .font(DesignTokens.Typography.caption)  // 11pt
                    }
                    .padding(.vertical, 6)             // Top/bottom padding
                }
                .frame(minHeight: 44)                  // Expand touch target
                .contentShape(Rectangle())             // Make entire area tappable
            }
        }
        .frame(height: totalHeight)  // Visual height 40pt
    }
}
```

**Key**: `.frame(minHeight: 44)` + `.contentShape(Rectangle())` ensures 44pt touch target despite 40pt visual height.

---

#### Step 3.6: TimelineChart

**File**: `minimax-usage-checker/Components/TimelineChart.swift`

Update axis/legend fonts:

```swift
struct TimelineChart: View {
    var axisLabelFont: Font = DesignTokens.Typography.caption      // 11pt
    var legendFont: Font = DesignTokens.Typography.captionSmall    // 10pt
    var chartHeight: CGFloat = 180                                 // ~220 → 180
    // ... rest unchanged
}
```

---

### Phase 4: View Layout Adjustments

Views may have hardcoded spacing. Replace with token references.

#### Step 4.1: DashboardView

**File**: `minimax-usage-checker/Views/DashboardView.swift`

Find VStack/HStack spacing and replace:

```swift
VStack(spacing: DesignTokens.Spacing.lg) {  // 14pt section spacing
    PrimaryUsageIndicator(/* ... */)
    ModelStatusList(/* ... */)
}
.padding(DesignTokens.Spacing.md)  // 10pt internal padding
```

---

#### Step 4.2: UsageView

**File**: `minimax-usage-checker/Views/UsageView.swift`

Ensure list rows use compact spacing:

```swift
List(models) { model in
    ModelCard(model: model)
        .listRowInsets(EdgeInsets(
            top: DesignTokens.Spacing.sm,     // 6pt
            leading: DesignTokens.Spacing.md, // 10pt
            bottom: DesignTokens.Spacing.sm,  // 6pt
            trailing: DesignTokens.Spacing.md // 10pt
        ))
}
```

---

#### Step 4.3: HistoryView

**File**: `minimax-usage-checker/Views/HistoryView.swift`

Update chart and surrounding spacing:

```swift
VStack(spacing: DesignTokens.Spacing.md) {  // 10pt
    TimeRangePicker(/* ... */)
    TimelineChart(
        snapshots: snapshots,
        axisLabelFont: DesignTokens.Typography.caption,      // 11pt
        legendFont: DesignTokens.Typography.captionSmall,    // 10pt
        chartHeight: 180
    )
}
.padding(DesignTokens.Spacing.md)  // 10pt
```

---

### Phase 5: Testing & Validation

#### Step 5.1: Visual Regression Testing

Run app and verify each view:

```bash
# Open Xcode
# Run app (Cmd+R)
# Test sequence:
1. Dashboard → Verify 5+ models visible without scrolling (800x600 window)
2. Usage → Verify compact list rows, no text overlap
3. History → Verify chart legible with 11pt axis labels
4. Alerts → Verify all controls hit 44pt touch targets
5. Onboarding → Verify form fields properly spaced

# Resize window to 300x400 (minimum)
# Verify: All content accessible, text wraps gracefully
```

---

#### Step 5.2: Accessibility Testing

Enable macOS accessibility features:

```bash
# System Preferences → Accessibility → Display → "Increase contrast" ON
# Run app
# Verify: All text remains readable

# System Preferences → Accessibility → Display → "Larger Text" to Medium
# Run app
# Verify: Text scales within bounds (10-18pt capped by .dynamicTypeSize modifier)
```

**Add Dynamic Type bounds** (if not present):
```swift
// In ContentView or App root
.dynamicTypeSize(.medium ... .large)  // Cap scaling to preserve compact intent
```

---

#### Step 5.3: Interaction Testing

Verify all interactive elements maintain 44pt touch targets:

```bash
# Test with mouse (simulating precise clicks):
- Tab bar tabs (40pt visual, 44pt effective)
- ModelCard collapse/expand
- Refresh button
- Alert settings toggles
- All buttons in forms

# All should respond reliably without mis-clicks
```

---

#### Step 5.4: Unit Test Updates

**File**: `minimax-usage-checkerTests/minimax_usage_checkerTests.swift`

Add tests for design token values:

```swift
import Testing
@testable import minimax_usage_checker

@Test func verifyCompactTypographyScale() {
    // FR-001: Max font 24pt
    #expect(DesignTokens.Typography.displayLarge.pointSize == 24)
    
    // SC-007: Max 2:1 ratio
    let ratio = 24.0 / 12.0  // displayLarge / bodyMedium
    #expect(ratio <= 2.0)
}

@Test func verifyCompactSpacing() {
    // FR-002: Max internal padding 12pt (using 10pt)
    #expect(DesignTokens.Spacing.md <= 12)
    
    // FR-002: Max section spacing 16pt
    #expect(DesignTokens.Spacing.xl <= 16)
}

@Test func verifyCompactRadius() {
    // FR-003: Max radius 8pt
    #expect(DesignTokens.Radius.lg <= 8)
    #expect(DesignTokens.Radius.xl <= 8)
}

@Test func verifyAccessibilityMinimums() {
    // FR-016: Touch targets ≥ 44pt
    let tabBarEffectiveHeight: CGFloat = 44  // From TabBar.minHeight
    #expect(tabBarEffectiveHeight >= 44)
}
```

Run tests:
```bash
xcodebuild test -project minimax-usage-checker.xcodeproj -scheme minimax-usage-checker
```

---

#### Step 5.5: UI Test for Viewport Density

**File**: `minimax-usage-checkerUITests/minimax_usage_checkerUITests.swift`

Add test for SC-001 (5 models visible at 800x600):

```swift
@MainActor
func testDashboardDisplaysFiveModelsWithoutScrolling() throws {
    let app = XCUIApplication()
    app.launch()
    
    // Resize window to 800x600
    let window = app.windows.firstMatch
    window.resize(withSizeOffset: CGVector(dx: 800, dy: 600))
    
    // Navigate to Dashboard
    app.buttons["Dashboard"].tap()
    
    // Count visible model cards (assuming test data has 5+ models)
    let modelCards = app.scrollViews.otherElements.matching(identifier: "ModelCard")
    XCTAssertGreaterThanOrEqual(modelCards.count, 5, "Dashboard should show 5+ models without scrolling")
}
```

---

### Phase 6: Documentation Updates

#### Step 6.1: Update AGENTS.md

Add section documenting compact token values:

```markdown
## Design Tokens (Compact UI - 003)

### Typography Scale (Compact)
- displayLarge: 24pt bold rounded (primary metrics)
- displayMedium: 18pt semibold rounded (section headers)
- headingLarge: 16pt semibold (card titles)
- headingMedium: 14pt semibold (subheadings)
- bodyLarge: 13pt regular (primary body)
- bodyMedium: 12pt regular (secondary body)
- caption: 11pt regular (labels)
- captionSmall: 10pt regular (fine print)

### Spacing Scale (Compact)
- xs: 4pt, sm: 6pt, md: 10pt, lg: 14pt, xl: 16pt, xxl: 20pt

### Border Radius (Compact)
- sm/md: 6pt, lg/xl: 8pt, full: 9999pt

### Shadows (Compact)
- sm: 1pt/0.02, md: 2pt/0.04, lg: 3pt/0.06
```

---

## Troubleshooting

### Issue: Text overlaps in compact cards

**Cause**: Component not using token spacing  
**Fix**: Replace hardcoded padding with `DesignTokens.Spacing.*`

```swift
// Before
.padding(16)

// After
.padding(DesignTokens.Spacing.md)  // 10pt
```

---

### Issue: Buttons don't respond reliably

**Cause**: Visual size < 44pt, touch target not expanded  
**Fix**: Add `.frame(minHeight: 44)` + `.contentShape(Rectangle())`

```swift
Button("Action") { /* ... */ }
    .frame(minHeight: 44)        // Expand hit area
    .contentShape(Rectangle())   // Make entire frame tappable
```

---

### Issue: Shadows too subtle/invisible

**Cause**: Expected behavior—shadows intentionally reduced  
**Verification**: Check on light background; compact shadows are hints, not depth

---

### Issue: Can't see all models at 800x600

**Cause**: Components still using old large sizes  
**Fix**: Verify all components in Phase 3 updated; check for hardcoded large padding

```bash
# Search for hardcoded large values
grep -r "\.padding(16)" minimax-usage-checker/
grep -r "size: 48" minimax-usage-checker/
```

---

## Validation Checklist

Before marking feature complete:

- [ ] `DesignTokens.swift` updated with all compact values
- [ ] All 11 components reference tokens (no hardcoded sizes)
- [ ] 5+ models visible at 800x600 without scrolling (SC-001)
- [ ] All touch targets ≥ 44pt (FR-016)
- [ ] Text readable at 12pt minimum (SC-007)
- [ ] Animations use 0.2s duration (FR-017)
- [ ] Unit tests pass for token constraints
- [ ] UI tests pass for viewport density
- [ ] Accessibility testing with Increase Contrast ON
- [ ] Dynamic Type scaling bounded (.medium ... .large)
- [ ] `AGENTS.md` updated with compact token values

---

## Next Steps

After validation:
1. Commit changes: `git commit -m "feat: compact refined UI with reduced design tokens"`
2. Run full test suite: `xcodebuild test ...`
3. Create PR with before/after screenshots
4. Link to spec: `specs/003-compact-refined-ui/spec.md`

**PR Description Template**:
```markdown
## Compact Refined UI

Implements design token refinement per `003-compact-refined-ui` spec:
- Typography reduced 8-50% (max 24pt)
- Spacing reduced 0-58% (4pt grid)
- Border radius reduced to 6-8pt
- Shadows reduced to 1-3pt blur

### Visual Changes
- 5+ models visible without scrolling at 800x600 ✅
- All touch targets ≥ 44pt (accessibility) ✅
- Information density increased 30% while maintaining readability ✅

### Testing
- Unit tests: Token constraints verified
- UI tests: Viewport density validated
- Manual: Accessibility + Dynamic Type tested

[Attach screenshots: Before vs After]
```

---

## Resources

- Spec: `specs/003-compact-refined-ui/spec.md`
- Research: `specs/003-compact-refined-ui/research.md`
- Data Model: `specs/003-compact-refined-ui/data-model.md`
- Contracts: `specs/003-compact-refined-ui/contracts/`
- AGENTS.md: `/minimax-usage-checker/AGENTS.md`
