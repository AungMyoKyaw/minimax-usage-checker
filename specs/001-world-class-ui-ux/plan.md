# Implementation Plan: World-Class UI/UX Redesign

**Branch**: `001-world-class-ui-ux` | **Date**: 2026-02-14 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-world-class-ui-ux/spec.md`

## Summary

Transform the MiniMax Usage Checker into a world-class macOS application through a comprehensive UI/UX redesign. The implementation focuses on seven core principles: Radical Simplicity, Purposeful Motion, Typography as Architecture, Breathing Room, Color as Communication, Subtle Depth, and Delight in Detail. This plan establishes a design system with reusable components, thoughtful animations, and a cohesive visual language that elevates the app from functional to exceptional.

## Technical Context

**Language/Version**: Swift 5.9+
**Primary Dependencies**: SwiftUI (native), Charts framework, Combine, UserNotifications
**Storage**: UserDefaults (API key, snapshots) - no changes needed
**Testing**: Swift Testing framework (XCTest compatible), UI tests via XCUITest
**Target Platform**: macOS 12.0+ (Monterey)
**Project Type**: Native macOS single-window application
**Performance Goals**: 60fps animations, <100ms interaction feedback, <400ms view transitions
**Constraints**: Native-only (no third-party UI libraries), accessibility compliant, dark/light mode support
**Scale/Scope**: 3 main views, ~15 reusable components, 32 functional requirements

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The project constitution is in template state (no specific constraints defined). The following gates apply based on AGENTS.md and project context:

| Gate | Status | Notes |
|------|--------|-------|
| Native macOS Only | ✅ PASS | Using SwiftUI + Apple frameworks exclusively |
| MVVM Architecture | ✅ PASS | Existing architecture preserved, views enhanced |
| No External Dependencies | ✅ PASS | Only Apple frameworks used |
| Accessibility | ✅ PASS | WCAG 4.5:1 contrast, keyboard navigation, VoiceOver |
| Performance Standards | ✅ PASS | Animation durations <400ms, feedback <100ms |

**Post-Design Re-Check**: Required after Phase 1 to verify component contracts maintain standards.

## Project Structure

### Documentation (this feature)

```text
specs/001-world-class-ui-ux/
├── plan.md              # This file
├── research.md          # Phase 0: Design system research, animation patterns
├── data-model.md        # Phase 1: UI state models, design tokens
├── quickstart.md        # Phase 1: Implementation guide
├── contracts/           # Phase 1: Component specifications
│   ├── design-tokens.md
│   ├── components.md
│   └── animations.md
└── checklists/
    └── requirements.md  # Specification quality checklist
```

### Source Code (repository root)

```text
minimax-usage-checker/
├── minimax-usage-checker/
│   ├── minimax_usage_checkerApp.swift    # App entry point
│   ├── ContentView.swift                 # Main view (REDESIGN)
│   ├── UsageViewModel.swift              # ViewModel (minimal changes)
│   ├── MiniMaxAPIService.swift           # API service (no changes)
│   ├── CodingPlanModels.swift            # Data models (no changes)
│   ├── NotificationManager.swift         # Notifications (no changes)
│   │
│   ├── DesignSystem/                     # NEW: Design system
│   │   ├── DesignTokens.swift            # Colors, typography, spacing
│   │   ├── Animations.swift              # Animation curves and durations
│   │   └── Shadows.swift                 # Shadow definitions
│   │
│   ├── Components/                       # NEW: Reusable components
│   │   ├── CircularProgressView.swift    # Time-based progress
│   │   ├── LinearProgressView.swift      # Count-based progress
│   │   ├── StatCard.swift                # Dashboard stat card
│   │   ├── ModelCard.swift               # Model usage card
│   │   ├── EmptyStateView.swift          # Empty/error states
│   │   ├── TabBar.swift                  # Custom tab navigation
│   │   ├── TimelineChart.swift           # History visualization
│   │   └── TooltipView.swift             # Hover information
│   │
│   ├── Views/                            # NEW: Organized view structure
│   │   ├── OnboardingView.swift          # API key entry screen
│   │   ├── DashboardView.swift           # Main dashboard
│   │   ├── UsageView.swift               # Model usage list
│   │   ├── HistoryView.swift             # Usage history
│   │   └── ModelDetailView.swift         # Expanded model details
│   │
│   └── Assets.xcassets/
│       ├── Colors/                       # NEW: Semantic colors
│       └── AppIcon.appiconset/
│
├── minimax-usage-checkerTests/
│   ├── DesignSystemTests.swift           # NEW: Token validation
│   ├── ComponentTests.swift              # NEW: Component behavior
│   └── minimax_usage_checkerTests.swift  # Existing tests
│
└── minimax-usage-checkerUITests/
    ├── OnboardingFlowTests.swift         # NEW: Onboarding UI tests
    ├── DashboardTests.swift              # NEW: Dashboard UI tests
    └── NavigationTests.swift             # NEW: Tab navigation tests
```

**Structure Decision**: Extending existing single-project structure with organized directories for DesignSystem, Components, and Views. This maintains the existing architecture while introducing clear separation of concerns for the UI layer.

## Complexity Tracking

> No constitutional violations. Design decisions documented below.

| Decision | Rationale |
|----------|-----------|
| Separate DesignSystem folder | Centralizes tokens for consistency; single source of truth |
| Component-based architecture | Enables reuse, testing, and iterative refinement |
| Views folder organization | Scales better than single ContentView file |
| No third-party libraries | Maintains native feel and reduces dependencies |

---

## Phase 0: Research Summary

See [research.md](./research.md) for detailed findings.

### Key Decisions

1. **Animation Framework**: Use SwiftUI's native animation system with custom timing curves
2. **Color System**: Semantic color naming with light/dark mode variants
3. **Typography Scale**: 8-point grid system with SwiftUI's dynamic type
4. **Component Strategy**: Small, composable components with clear prop interfaces
5. **State Management**: Leverage existing ViewModel pattern, add @Published UI state

---

## Phase 1: Design Artifacts

| Artifact | Path | Purpose |
|----------|------|---------|
| Data Model | [data-model.md](./data-model.md) | UI state models, design tokens structure |
| Design Tokens | [contracts/design-tokens.md](./contracts/design-tokens.md) | Color, typography, spacing specifications |
| Components | [contracts/components.md](./contracts/components.md) | Reusable component specifications |
| Animations | [contracts/animations.md](./contracts/animations.md) | Motion design system |
| Quickstart | [quickstart.md](./quickstart.md) | Implementation guide for developers |
