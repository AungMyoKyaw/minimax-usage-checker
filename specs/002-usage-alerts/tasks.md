---

description: "Task list template for feature implementation"
---

# Tasks: Usage Alerts

**Input**: Design documents from `/specs/002-usage-alerts/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Tests are not explicitly requested in the spec - following the feature specification guidance

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Build existing project to verify current state in minimax-usage-checker/
- [x] T002 [P] Create AlertModels.swift with AlertType, SnoozeDuration, ValidationError enums in minimax-usage-checker/AlertModels.swift

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T003 [P] Implement AlertSettings struct with Codable in minimax-usage-checker/AlertSettings.swift
- [x] T004 [P] Implement ModelAlertSettings struct with Codable in minimax-usage-checker/ModelAlertSettings.swift
- [x] T005 [P] Implement AlertHistoryEntry struct with Codable in minimax-usage-checker/AlertHistoryEntry.swift
- [x] T006 Create AlertSettingsManager singleton for UserDefaults persistence in minimax-usage-checker/AlertSettingsManager.swift
- [x] T007 Create AlertHistoryManager singleton for history storage in minimax-usage-checker/AlertHistoryManager.swift
- [x] T008 Update NotificationManager to use configurable thresholds in minimax-usage-checker/NotificationManager.swift

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Configure Alert Thresholds (Priority: P1) 🎯 MVP

**Goal**: Allow users to configure global warning and critical thresholds with default values

**Independent Test**: Open settings, change threshold values, verify values persist after app restart

### Implementation for User Story 1

- [x] T009 [P] [US1] Add global threshold properties to UsageViewModel in minimax-usage-checker/UsageViewModel.swift
- [x] T010 [US1] Create AlertSettingsView SwiftUI component in minimax-usage-checker/Views/AlertSettingsView.swift
- [x] T011 [US1] Add Alerts tab to ContentView navigation in minimax-usage-checker/ContentView.swift
- [x] T012 [US1] Wire AlertSettingsManager to AlertSettingsView in minimax-usage-checker/Views/AlertSettingsView.swift
- [x] T013 [US1] Add validation (Warning > Critical) to AlertSettingsManager in minimax-usage-checker/AlertSettingsManager.swift

**Checkpoint**: User Story 1 fully functional - users can configure thresholds

---

## Phase 4: User Story 2 - Per-Model Alert Configuration (Priority: P2)

**Goal**: Allow users to set different thresholds for different models

**Independent Test**: Set 70% threshold for one model and 90% for another, verify each triggers at respective level

### Implementation for User Story 2

- [x] T014 [P] [US2] Add per-model override methods to AlertSettingsManager in minimax-usage-checker/AlertSettingsManager.swift
- [x] T015 [P] [US2] Add enabledModels tracking to AlertSettings in minimax-usage-checker/AlertSettings.swift
- [x] T016 [US2] Create PerModelSettingsView SwiftUI component in minimax-usage-checker/Views/PerModelSettingsView.swift
- [x] T017 [US2] Integrate per-model settings into AlertSettingsView in minimax-usage-checker/Views/AlertSettingsView.swift
- [x] T018 [US2] Update NotificationManager to check per-model thresholds in minimax-usage-checker/NotificationManager.swift

**Checkpoint**: User Stories 1 AND 2 both functional independently

---

## Phase 5: User Story 3 - Alert History (Priority: P3)

**Goal**: Display history of past alerts with timestamps

**Independent Test**: Trigger several alerts, view history, verify all alerts listed with timestamps

### Implementation for User Story 3

- [x] T019 [P] [US3] Add addEntry method to AlertHistoryManager in minimax-usage-checker/AlertHistoryManager.swift
- [x] T020 [P] [US3] Add clearHistory method to AlertHistoryManager in minimax-usage-checker/AlertHistoryManager.swift
- [x] T021 [US3] Create AlertHistoryView SwiftUI component in minimax-usage-checker/Views/AlertHistoryView.swift
- [x] T022 [US3] Update NotificationManager to record alerts in history in minimax-usage-checker/NotificationManager.swift
- [x] T023 [US3] Add AlertHistoryView to main navigation in minimax-usage-checker/ContentView.swift

**Checkpoint**: Alert history is visible and functional

---

## Phase 6: User Story 4 - Snooze Alerts (Priority: P3)

**Goal**: Allow users to temporarily pause alerts

**Independent Test**: Snooze alerts for 1 hour, verify no notifications during that period

### Implementation for User Story 4

- [x] T024 [P] [US4] Add snooze/unsnooze methods to AlertSettingsManager in minimax-usage-checker/AlertSettingsManager.swift
- [x] T025 [P] [US4] Add isSnoozed computed property with time check in minimax-usage-checker/AlertSettingsManager.swift
- [x] T026 [US4] Create SnoozeOptionsView SwiftUI component in minimax-usage-checker/Views/SnoozeOptionsView.swift
- [x] T027 [US4] Integrate snooze UI into AlertSettingsView in minimax-usage-checker/Views/AlertSettingsView.swift
- [x] T028 [US4] Update NotificationManager to check snooze state before sending in minimax-usage-checker/NotificationManager.swift

**Checkpoint**: Snooze functionality works correctly

---

## Phase 7: User Story 5 - Custom Alert Messages (Priority: P4)

**Goal**: Allow users to customize notification message templates

**Independent Test**: Set custom message template, trigger alert, verify custom message appears

### Implementation for User Story 5

- [x] T029 [P] [US5] Add custom message fields to AlertSettings in minimax-usage-checker/AlertSettings.swift
- [x] T030 [P] [US5] Add custom message methods to AlertSettingsManager in minimax-usage-checker/AlertSettingsManager.swift
- [x] T031 [US5] Create CustomMessageView SwiftUI component in minimax-usage-checker/Views/CustomMessageView.swift
- [x] T032 [US5] Update NotificationManager to use custom messages in minimax-usage-checker/NotificationManager.swift

**Checkpoint**: All user stories complete

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [x] T033 [P] Add unit tests for AlertSettingsManager in minimax-usage-checkerTests/AlertSettingsManagerTests.swift
- [x] T034 [P] Add unit tests for AlertHistoryManager in minimax-usage-checkerTests/AlertHistoryManagerTests.swift
- [x] T035 Run quickstart.md validation in specs/002-usage-alerts/quickstart.md
- [x] T036 Update AGENTS.md with new feature implementation notes

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can proceed in parallel (if staffed) or sequentially in priority order
- **Polish (Final Phase)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational - Uses AlertSettingsManager from foundation
- **User Story 3 (P3)**: Can start after Foundational - Uses AlertHistoryManager from foundation
- **User Story 4 (P3)**: Can start after Foundational - Uses AlertSettingsManager from foundation
- **User Story 5 (P4)**: Can start after Foundational - Uses AlertSettingsManager from foundation

### Within Each User Story

- Models before services
- Services before UI
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- Phase 1 tasks T001-T002 can run in parallel
- Phase 2 tasks T003-T005 can run in parallel
- Once Foundational completes, all user stories can start in parallel
- US2 tasks T014-T015 can run in parallel
- US3 tasks T019-T020 can run in parallel
- US4 tasks T024-T025 can run in parallel
- US5 tasks T029-T030 can run in parallel

---

## Parallel Example: User Story 1

```bash
# Launch all implementation for User Story 1:
Task: "Add global threshold properties to UsageViewModel"
Task: "Create AlertSettingsView SwiftUI component"
Task: "Add Alerts tab to ContentView navigation"
Task: "Wire AlertSettingsManager to AlertSettingsView"
Task: "Add validation to AlertSettingsManager"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Add User Story 4 → Test independently → Deploy/Demo
6. Add User Story 5 → Test independently → Deploy/Demo
7. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1 (MVP)
   - Developer B: User Story 2
   - Developer C: User Story 3
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
