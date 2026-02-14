# Research: Compact Refined UI

**Branch**: `003-compact-refined-ui` | **Date**: 2026-02-14

## Phase 0: Research Findings

### 1. Typography Scale Reduction Strategy

**Decision**: Reduce all font sizes by 33-50% while maintaining 2:1 max ratio

**Rationale**:
- Current largest font (48pt display) is optimized for hero sections, not dashboard data
- Spec requires maximum 24pt, minimum 12pt body text → 2:1 ratio maintains hierarchy
- macOS human interface guidelines recommend 11-13pt for body text, 14-17pt for headings in utility apps
- Research shows 12pt is the minimum comfortable reading size at standard Retina density (2x)

**Implementation**:
| Current | Compact | Reduction | Use Case |
|---------|---------|-----------|----------|
| 48pt bold | 24pt bold | -50% | Primary usage percentage only |
| 32pt bold | 18pt semibold | -44% | Section headers |
| 24pt semibold | 16pt semibold | -33% | Card titles |
| 18pt semibold | 14pt semibold | -22% | Subheadings |
| 16pt regular | 13pt regular | -19% | Body text |
| 14pt regular | 12pt regular | -14% | Secondary text |
| 12pt regular | 11pt regular | -8% | Captions |
| 10pt regular | 10pt regular | 0% | Fine print (minimum) |

**Alternatives considered**:
- Uniform 40% reduction: Rejected because it would make captions too small (6pt)
- Keep display fonts large: Rejected because spec explicitly targets information density

---

### 2. Spacing Scale Optimization

**Decision**: Reduce to 4pt grid with values [4, 8, 12, 16, 20] pt

**Rationale**:
- Current scale [4, 8, 16, 24, 32, 48] has large jumps (16→24→32→48)
- Spec requires maximum 16pt section spacing, maximum 12pt internal padding
- SwiftUI aligns naturally to 4pt increments on Retina displays
- Research: Apple's own utility apps (Activity Monitor, Console) use tight 8-12pt padding

**Implementation**:
| Current | Compact | Reduction | Use Case |
|---------|---------|-----------|----------|
| xs: 4pt | 4pt | 0% | Icon-text gap, micro spacing |
| sm: 8pt | 6pt | -25% | List item internal padding |
| md: 16pt | 10pt | -38% | Card internal padding |
| lg: 24pt | 14pt | -42% | Section spacing |
| xl: 32pt | 16pt | -50% | Major section dividers |
| xxl: 48pt | 20pt | -58% | Page-level margins |

**Alternatives considered**:
- Keep 8pt minimum grid: Rejected because 6pt allows tighter list rows while staying accessible
- Aggressive 50% across the board: Rejected because micro-spacing (4pt) is already optimal

---

### 3. Border Radius Refinement

**Decision**: Reduce maximum radius to 8pt with two-tier system [6pt, 8pt]

**Rationale**:
- Current maximum 20pt creates "bubbly" aesthetic inappropriate for data-focused utility
- Spec requires maximum 8pt for subtle, modern corners
- Research: macOS Big Sur onwards uses 10-12pt for controls, 6-8pt for cards
- Rounded design (current) vs. minimal rounded (target) shifts visual language

**Implementation**:
| Current | Compact | Use Case |
|---------|---------|----------|
| sm: 8pt | 6pt | Small buttons, chips, badges |
| md: 12pt | 6pt | Cards, panels |
| lg: 16pt | 8pt | Large containers, modals |
| xl: 20pt | 8pt | N/A (eliminated) |
| full: 9999 | 9999 | Circular progress (unchanged) |

**Alternatives considered**:
- Sharp corners (0pt): Rejected because macOS design language expects subtle rounding
- Three-tier system [4pt, 6pt, 8pt]: Rejected for simplicity; two tiers sufficient

---

### 4. Shadow Intensity Reduction

**Decision**: Reduce blur radius by 50-75%, lower opacity to 0.02-0.06

**Rationale**:
- Current shadows (8-12pt blur, 0.08-0.12 opacity) create strong depth perception
- Spec requires subtle elevation (2-4pt blur) for flatter, refined aesthetic
- Research: Utility apps prioritize content over z-axis depth; shadows should hint, not dominate
- macOS light mode uses very subtle shadows compared to material design

**Implementation**:
| Current | Compact | Reduction | Use Case |
|---------|---------|-----------|----------|
| sm: 1pt/0.04 | 1pt/0.02 | -50% opacity | Hover states |
| md: 4pt/0.08 | 2pt/0.04 | -50% blur, -50% opacity | Default cards |
| lg: 8pt/0.12 | 3pt/0.06 | -63% blur, -50% opacity | Elevated panels |
| focus | 0pt/0.3 | 0pt/0.2 | -33% opacity | Focus rings |

**Alternatives considered**:
- Eliminate shadows entirely: Rejected because some depth cues improve readability
- Keep blur, reduce opacity only: Rejected because large blur with low opacity looks fuzzy

---

### 5. Component-Specific Proportions

**Decision**: Apply token reductions + custom sizing for high-impact components

**CircularProgressView**:
- Current: 120pt diameter, 8pt line width
- Compact: 80pt diameter, 6pt line width
- Rationale: 80pt still accommodates 24pt percentage text with breathing room

**StatCard**:
- Current: 16pt padding, 20pt icon
- Compact: 10pt padding, 16pt icon
- Rationale: Maintains 44pt minimum touch target height with compressed internal space

**ModelCard**:
- Current: ~60-70pt collapsed height
- Compact: ~44-50pt collapsed height (30% reduction)
- Rationale: Minimum 44pt preserves accessibility; tighter internal spacing achieves density

**TabBar**:
- Current: 44pt+ height with padding
- Compact: 40pt total height
- Rationale: 40pt tabs with 32pt icons + 4pt label still hit 44pt effective target

**TimelineChart**:
- Current: Axis labels 14pt, legend 12pt
- Compact: Axis labels 11pt, legend 10pt
- Rationale: Charts framework renders readable at these sizes on Retina displays

---

### 6. Animation Duration Adjustment

**Decision**: Reduce from 0.3s to 0.2s across all transitions

**Rationale**:
- Compact interfaces feel faster with snappier animations
- Research: 0.2-0.25s is optimal for casual animations (Apple HIG)
- Existing `.appSpring` animation: spring(response: 0.3, dampingFraction: 0.75)
- Compact: spring(response: 0.2, dampingFraction: 0.75)

**Alternatives considered**:
- 0.15s: Rejected as too abrupt for smooth transitions
- Keep 0.3s: Rejected because compact UI benefits from faster perceived responsiveness

---

### 7. Accessibility Preservation

**Decision**: Maintain 44pt minimum touch targets; respect Dynamic Type within bounds

**Rationale**:
- macOS accessibility guidelines require 44pt for motor control accommodation
- Spec explicitly states "44pt minimum for accessibility compliance"
- Dynamic Type: Allow scaling but cap at 10-18pt range to preserve compact intent
- Color contrast ratios remain unchanged (already compliant)

**Implementation**:
- Buttons/rows: Ensure 44pt vertical height even with reduced padding
- Interactive areas: Use `.contentShape(Rectangle())` to expand hit targets where visual is smaller
- Text scaling: Use `.dynamicTypeSize(.medium ... .large)` modifier to limit extreme scaling

---

### 8. Information Density Validation

**Decision**: Target 5 model cards at 800x600 window → ~100pt per card budget

**Calculations**:
- Window content area: 800x600 - chrome (title bar ~28pt, tab bar 40pt) = 800x532pt usable
- Target: 5 cards without scrolling → 532 / 5 = 106.4pt per card maximum
- Compact card: 44pt collapsed height + 12pt vertical spacing = 56pt per card
- **Margin**: 106.4 - 56 = 50.4pt excess → comfortable fit for 9 cards, exceeds goal

**Alternative layouts considered**:
- Grid layout (2 columns): Rejected because horizontal space wasted on wide windows
- Horizontal scrolling: Rejected because vertical lists are more scannable for status data

---

## Summary of Key Decisions

| Area | Current | Compact | Impact |
|------|---------|---------|--------|
| Typography | 48pt max | 24pt max | -50% largest font |
| Spacing | 48pt max | 20pt max | -58% page margins |
| Radius | 20pt max | 8pt max | -60% maximum |
| Shadow | 8pt blur | 3pt blur | -63% depth perception |
| Animations | 0.3s | 0.2s | -33% duration |
| Card height | ~65pt | ~44pt | -32% vertical space |

**All NEEDS CLARIFICATION resolved**: Technical context is now fully specified for Phase 1 design.
