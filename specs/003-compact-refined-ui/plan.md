# Implementation Plan: Compact Refined UI

**Branch**: `003-compact-refined-ui` | **Date**: 2026-02-14 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/003-compact-refined-ui/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Refine the existing macOS application interface to achieve compact, information-dense design inspired by Jony Ive's principles: reduction, simplicity, precision, and proportion. All design tokens (typography, spacing, borders, shadows) will be reduced by 25-40% while preserving readability and accessibility. The goal is to display 5+ model cards without scrolling in an 800x600 window, maintaining all existing functionality.

## Technical Context

**Language/Version**: Swift 5.9+ (Xcode 15.0+)  
**Primary Dependencies**: SwiftUI, Charts (native Apple frameworks), Combine, UserNotifications  
**Storage**: UserDefaults (API key, snapshots, alert settings)  
**Testing**: Swift Testing (unit), XCTest (UI tests)  
**Target Platform**: macOS 12.0+ (Monterey)  
**Project Type**: Single native macOS application (MVVM architecture)  
**Performance Goals**: UI remains responsive with 60fps animations; under 2-second scan time for 5 models  
**Constraints**: Must maintain 44pt minimum touch targets (accessibility); respects macOS Dynamic Type; compact doesn't mean cramped  
**Scale/Scope**: Existing application with ~20 components, 5 views, all visual refinement (no new features)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Constitution Status**: Template constitution detected (not yet customized). No project-specific gates enforced.

**Evaluation**:
- ✅ No new dependencies introduced (existing SwiftUI/Charts/Combine only)
- ✅ Visual-only refactor, no behavioral changes
- ✅ Existing Swift Testing + XCTest preserved
- ✅ No breaking changes to data layer, API, or persistence

**Gate Result**: PASS (no constitution violations; visual refinement within existing constraints)

## Project Structure

### Documentation (this feature)

```text
specs/003-compact-refined-ui/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
└── contracts/           # Phase 1 output (/speckit.plan command)
```

### Source Code (repository root)

```text
minimax-usage-checker/
├── minimax-usage-checker/
│   ├── DesignSystem/              # Design tokens & types (MODIFICATION FOCUS)
│   │   ├── DesignTokens.swift     # ← PRIMARY CHANGE: Reduce all values 25-40%
│   │   ├── Animations.swift       # ← Reduce duration 0.3s → 0.2s
│   │   ├── UsageStatus.swift      # No change
│   │   ├── EmptyStateType.swift   # No change
│   │   └── ErrorStateType.swift   # No change
│   ├── Components/                # Reusable UI components (PROPORTIONAL UPDATES)
│   │   ├── CircularProgressView.swift    # ← 120pt → 80pt diameter
│   │   ├── LinearProgressView.swift      # ← Line width 8pt → 6pt
│   │   ├── ModelCard.swift               # ← Reduce padding 16pt → 10-12pt
│   │   ├── StatCard.swift                # ← Reduce padding/icon size
│   │   ├── TabBar.swift                  # ← Height 44pt → 40pt
│   │   ├── TimelineChart.swift           # ← Adjust axes/legend sizing
│   │   └── [11 other components]         # ← Apply token changes
│   ├── Views/                     # Main app views (LAYOUT ADJUSTMENTS)
│   │   ├── DashboardView.swift    # ← Stack spacing reduction
│   │   ├── UsageView.swift        # ← Ensure compact list display
│   │   ├── HistoryView.swift      # ← Chart resizing
│   │   ├── MainView.swift         # ← Tab bar integration
│   │   └── OnboardingView.swift   # ← Form spacing reduction
│   └── Assets.xcassets/           # App icons & colors (NO CHANGE)
├── minimax-usage-checkerTests/    # Unit tests (VERIFY PROPORTIONS)
└── minimax-usage-checkerUITests/  # UI tests (ADD VIEWPORT TESTS)
```

**Structure Decision**: Existing single-project structure preserved. All changes confined to `DesignSystem/DesignTokens.swift` as the source of truth, with cascading updates to components/views that reference those tokens.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A | No constitution violations | N/A |
