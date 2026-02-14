# Research: World-Class UI/UX Redesign

**Date**: 2026-02-14
**Feature**: 001-world-class-ui-ux

---

## Research Tasks

### 1. SwiftUI Animation Best Practices

**Decision**: Use SwiftUI's native animation system with `.spring()` and `.easeInOut` timing curves

**Rationale**:
- SwiftUI animations are GPU-accelerated and optimized for macOS
- Spring animations feel natural for spatial transitions (view changes, expansions)
- Ease-based animations work best for value changes (number transitions, progress)
- No external dependencies required

**Alternatives Considered**:
| Alternative | Rejected Because |
|-------------|-----------------|
| Lottie animations | External dependency, overkill for micro-interactions |
| Custom CALayer animations | More complex, SwiftUI-native is sufficient |
| KeyframeAnimator (iOS 17+) | Not available on macOS 12 target |

**Implementation Pattern**:
```swift
// Spatial transitions (view changes)
.animation(.spring(response: 0.35, dampingFraction: 0.75), value: state)

// Value changes (progress, numbers)
.animation(.easeInOut(duration: 0.3), value: value)

// Reduce motion support
.animation(accessibilityReduceMotion ? .none : .spring(), value: state)
```

---

### 2. macOS Design Language & HIG

**Decision**: Follow Apple Human Interface Guidelines for macOS with custom refinements

**Rationale**:
- Native feel is expected by macOS users
- HIG provides proven patterns for spacing, typography, and interaction
- Custom refinements (like generous whitespace) enhance the experience without breaking familiarity

**Key HIG Principles Applied**:
| Principle | Application |
|-----------|-------------|
| Visual Hierarchy | Single dominant element on dashboard |
| Whitespace | Minimum 24px between major elements |
| Typography | SF Pro via system fonts, dynamic type support |
| Color | Semantic colors with light/dark variants |
| Depth | Subtle shadows to indicate layering |

---

### 3. Color System Design

**Decision**: Semantic color naming with status-based palette

**Rationale**:
- Semantic names (e.g., `usageSafe`, `usageWarning`) communicate purpose
- Light/dark variants ensure readability in both modes
- Status colors (green/orange/red) are universally understood

**Color Palette**:
| Token | Light Mode | Dark Mode | Usage |
|-------|------------|-----------|-------|
| `usageSafe` | #34C759 | #30D158 | <70% usage |
| `usageWarning` | #FF9500 | #FF9F0A | 70-90% usage |
| `usageCritical` | #FF3B30 | #FF453A | >90% usage |
| `surfacePrimary` | #FFFFFF | #1C1C1E | Card backgrounds |
| `surfaceSecondary` | #F2F2F7 | #2C2C2E | Nested containers |
| `borderSubtle` | #E5E5EA | #38383A | Card borders |

---

### 4. Typography Scale

**Decision**: 8-point grid with system fonts

**Rationale**:
- 8-point grid ensures consistent spacing and rhythm
- System fonts (SF Pro) are optimized for macOS and support dynamic type
- Limited scale prevents typographic chaos

**Typography Scale**:
| Token | Size | Weight | Usage |
|-------|------|--------|-------|
| `displayLarge` | 48pt | bold | Onboarding headlines |
| `displayMedium` | 32pt | bold | Section titles |
| `headingLarge` | 24pt | semibold | Card titles |
| `headingMedium` | 18pt | semibold | Subsections |
| `bodyLarge` | 16pt | regular | Primary content |
| `bodyMedium` | 14pt | regular | Secondary content |
| `caption` | 12pt | regular | Labels, hints |
| `captionSmall` | 10pt | regular | Fine print |

---

### 5. Animation Timing Curves

**Decision**: Three animation curves for different contexts

**Rationale**:
- Consistent timing creates cohesive feel
- Different physics for different purposes (spatial vs value)
- All durations under 400ms for perceived instant response

**Animation Specifications**:
| Name | Duration | Curve | Usage |
|------|----------|-------|-------|
| `transition` | 300ms | easeInOut | View changes, tab switches |
| `spring` | 350ms | spring(damping: 0.75) | Expansions, modal presentations |
| `subtle` | 200ms | easeOut | Hover states, micro-interactions |
| `value` | 250ms | easeInOut | Number transitions, progress |

---

### 6. Component Architecture

**Decision**: Small, single-purpose components with explicit interfaces

**Rationale**:
- Easier to test and iterate
- Clear prop interfaces make usage obvious
- Composable for complex views

**Component Categories**:
| Category | Components | Purpose |
|----------|------------|---------|
| Progress | CircularProgress, LinearProgress | Usage visualization |
| Cards | StatCard, ModelCard, TimelineCard | Information containers |
| States | EmptyState, ErrorState, LoadingState | Edge case handling |
| Navigation | TabBar, TabItem | View switching |
| Data | TimelineChart, Tooltip | Data visualization |

---

### 7. Accessibility Patterns

**Decision**: Full accessibility support without sacrificing design

**Rationale**:
- macOS users expect accessible apps
- Good accessibility often improves usability for everyone
- Legal and ethical requirements

**Accessibility Features**:
| Feature | Implementation |
|---------|---------------|
| Contrast | 4.5:1 minimum for all text |
| Keyboard Navigation | All interactive elements focusable |
| VoiceOver | Semantic labels on all elements |
| Dynamic Type | Layout adapts to font size changes |
| Reduce Motion | Disable animations when preference set |

---

### 8. State Management for UI

**Decision**: Extend existing ViewModel with UI-specific @Published properties

**Rationale**:
- Maintains existing architecture
- SwiftUI's @Published provides automatic view updates
- No need for external state management

**New ViewModel Properties**:
| Property | Type | Purpose |
|----------|------|---------|
| `isLoadingInitially` | Bool | First load vs refresh |
| `selectedModel` | ModelRemain? | Expanded model detail |
| `isRefreshing` | Bool | Pull-to-refresh state |
| `animationProgress` | Double | Animated transitions |

---

## Resolved Clarifications

All technical context items resolved. No NEEDS CLARIFICATION items remain.

---

## References

- [Apple Human Interface Guidelines - macOS](https://developer.apple.com/design/human-interface-guidelines/macos)
- [SwiftUI Animation Documentation](https://developer.apple.com/documentation/swiftui/animation)
- [SF Pro Typography](https://developer.apple.com/fonts/)
- [WCAG 2.1 Contrast Guidelines](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)
