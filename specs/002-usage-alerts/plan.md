# Implementation Plan: Usage Alerts

**Branch**: `002-usage-alerts` | **Date**: 2026-02-14 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/speckit.specify` command

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Enable users to configure custom usage alert thresholds with per-model settings, alert history tracking, and snooze functionality. Extends existing NotificationManager to support user-configurable thresholds stored in UserDefaults.

## Technical Context

**Language/Version**: Swift 5.9+  
**Primary Dependencies**: SwiftUI, Charts, UserNotifications, Foundation, Combine (all native Apple frameworks)  
**Storage**: UserDefaults for settings and alert history  
**Testing**: Swift Testing (unit tests), XCTest (UI tests)  
**Target Platform**: macOS 12.0+ (Monterey)  
**Project Type**: Single native macOS application  
**Performance Goals**: Alert checking within 1 second of data refresh cycle (30 seconds)  
**Constraints**: App Sandbox enabled, network client access required  
**Scale/Scope**: Up to 100 models monitored, 100 alert history entries

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

No constitution file found - using project defaults from AGENTS.md:
- Single project structure (no microservices)
- MVVM architecture with ObservableObject
- Native Apple frameworks only (no external dependencies)
- Test-first approach using Swift Testing and XCTest

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
minimax-usage-checker/
├── minimax-usage-checker/
│   ├── DesignSystem/           # Design tokens (existing)
│   ├── Components/             # Reusable UI components (existing)
│   ├── Views/                  # Main app views (existing)
│   ├── UsageViewModel.swift    # Main ViewModel (existing)
│   ├── NotificationManager.swift # Notifications - EXTEND for alerts feature
│   ├── AlertSettingsManager.swift # NEW - Alert settings persistence
│   ├── AlertHistoryManager.swift  # NEW - Alert history management
│   └── ...
└── ...
```

**Structure Decision**: Single SwiftUI app with MVVM. Adding new manager classes for alert settings and history, extending existing NotificationManager.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
