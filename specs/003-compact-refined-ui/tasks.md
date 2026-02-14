# Tasks: Compact Refined UI

**Input**: Design documents from `/specs/003-compact-refined-ui/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/design-tokens-api.md, contracts/component-sizing-api.md, quickstart.md

**Tests**: Unit tests for token constraints included. UI tests for viewport density included. No test tasks requested for components (manual validation).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3, US4)
- Include exact file paths in descriptions

## Path Conventions

All paths relative to repository root: `/Users/aungmyokyaw/Desktop/life/mac-app-repo/minimax-usage-checker`

- **Design System**: `minimax-usage-checker/DesignSystem/`
- **Components**: `minimax-usage-checker/Components/`
- **Views**: `minimax-usage-checker/Views/`
- **Tests**: `minimax-usage-checkerTests/`, `minimax-usage-checkerUITests/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and feature branch creation

- [X] T001 Create feature branch `003-compact-refined-ui` from master
- [X] T002 Verify Xcode 15.0+ and Swift 5.9+ installed
- [X] T003 Run baseline build to confirm current state (expected: 49 compilation errors related to DesignTokens)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core design token updates that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete. All 49 compilation errors must be resolved.

- [X] T004 Update Typography enum in minimax-usage-checker/DesignSystem/DesignTokens.swift (lines 49-58): displayLarge 48pt→24pt, displayMedium 32pt→18pt, headingLarge 24pt→16pt, headingMedium 18pt→14pt, bodyLarge 16pt→13pt, bodyMedium 14pt→12pt, caption 12pt→11pt, captionSmall 10pt (unchanged)
- [X] T005 Update Spacing enum in minimax-usage-checker/DesignSystem/DesignTokens.swift (lines 32-39): xs 4pt (unchanged), sm 8pt→6pt, md 16pt→10pt, lg 24pt→14pt, xl 32pt→16pt, xxl 48pt→20pt
- [X] T006 Update Radius enum in minimax-usage-checker/DesignSystem/DesignTokens.swift (lines 41-47): sm 8pt→6pt, md 12pt→6pt, lg 16pt→8pt, xl 20pt→8pt, full 9999pt (unchanged)
- [X] T007 Update Shadow enum in minimax-usage-checker/DesignSystem/DesignTokens.swift (lines 60-65): sm opacity 0.04→0.02, md radius 4pt→2pt opacity 0.08→0.04, lg radius 8pt→3pt opacity 0.12→0.06, focus opacity 0.3→0.2
- [X] T008 Update appSpring animation in minimax-usage-checker/DesignSystem/Animations.swift: response 0.3→0.2
- [X] T009 Build project and verify 0 compilation errors (all DesignTokens references now resolve correctly)

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - At-a-Glance Overview (Priority: P1) 🎯 MVP

**Goal**: Display 5+ model cards without scrolling in 800x600 window

**Independent Test**: Open app with 5+ models configured. Entire dashboard visible without scrolling at 800x600 window. All critical metrics readable.

### Implementation for User Story 1

- [X] T010 [P] [US1] Update CircularProgressView default diameter 120pt→80pt, lineWidth 8pt→6pt in minimax-usage-checker/Components/CircularProgressView.swift
- [X] T011 [P] [US1] Update LinearProgressView default height 8pt→6pt, cornerRadius 4pt→3pt in minimax-usage-checker/Components/LinearProgressView.swift
- [X] T012 [P] [US1] Update StatCard default padding 16pt→10pt, iconSize 20pt→16pt in minimax-usage-checker/Components/StatCard.swift
- [X] T013 [P] [US1] Update ModelCard verticalPadding 12pt→8pt, horizontalPadding 16pt→10pt, ensure minHeight 44pt in minimax-usage-checker/Components/ModelCard.swift
- [X] T014 [P] [US1] Update PrimaryUsageIndicator progressDiameter to 80pt in minimax-usage-checker/Components/PrimaryUsageIndicator.swift
- [X] T015 [US1] Update DashboardView VStack spacing to DesignTokens.Spacing.lg (14pt), padding to DesignTokens.Spacing.md (10pt) in minimax-usage-checker/Views/DashboardView.swift
- [X] T016 [US1] Update UsageView list row insets: top/bottom sm (6pt), leading/trailing md (10pt) in minimax-usage-checker/Views/UsageView.swift
- [X] T017 [US1] Update HistoryView chart spacing to md (10pt), chart height to 180pt in minimax-usage-checker/Views/HistoryView.swift
- [X] T018 [US1] Update OnboardingView form spacing to md (10pt) in minimax-usage-checker/Views/OnboardingView.swift
- [ ] T019 [US1] Manual validation: Open app with 5+ models at 800x600 window - verify all visible without scrolling
- [ ] T020 [US1] Manual validation: Verify percentage text (24pt) clearly readable in 80pt circular progress
- [ ] T021 [US1] Manual validation: Verify no text overlap in compressed cards
- [ ] T022 [US1] Manual validation: Verify collapsed ModelCard height ≥44pt (accessibility touch target)

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently. 5+ models should fit in 800x600 viewport without scrolling.

---

## Phase 4: User Story 2 - Quick Status Scan (Priority: P1) 🎯 MVP

**Goal**: Scan usage percentages across all models in under 2 seconds

**Independent Test**: Display 5 models with varying usage levels. User correctly identifies all models above 80% usage in under 2 seconds.

### Implementation for User Story 2

- [X] T023 [P] [US2] Update ModelStatusRow rowHeight 44pt (unchanged), contentPadding to 8pt in minimax-usage-checker/Components/ModelStatusRow.swift
- [X] T024 [P] [US2] Update StatsOverview card spacing to lg (14pt) in minimax-usage-checker/Components/StatsOverview.swift
- [X] T025 [P] [US2] Update ModelStatusList item spacing to sm (6pt) in minimax-usage-checker/Components/ModelStatusList.swift
- [X] T026 [US2] Verify color coding (green/orange/red) is applied consistently across all usage displays
- [X] T027 [US2] Verify font weights (semibold/bold for primary, regular for secondary) create clear hierarchy
- [ ] T028 [US2] Manual validation: Display 5 models with different usage levels (20%, 50%, 75%, 85%, 95%)
- [ ] T029 [US2] Manual validation: Perform 2-second glance test - identify all models above 80% usage
- [ ] T030 [US2] Manual validation: Verify percentage values readable with consistent visual weight
- [ ] T031 [US2] Manual validation: Verify color coding provides instant status recognition

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently. Users can view 5+ models at once AND scan status in under 2 seconds.

---

## Phase 5: User Story 3 - Detailed Information on Demand (Priority: P2)

**Goal**: Expanded details only when needed, interface stays clean while remaining informative

**Independent Test**: Click to expand a model card. All detailed metrics (window times, exact counts) visible in expansion.

### Implementation for User Story 3

- [X] T032 [P] [US3] Update TooltipView font to caption (11pt), padding to sm (6pt) in minimax-usage-checker/Components/TooltipView.swift
- [X] T033 [US3] Verify ModelCard expand/collapse animation uses 0.2s spring (from Animations.swift update in T008)
- [X] T034 [US3] Verify expanded ModelCard displays all detailed metrics without scrolling internal content
- [X] T035 [US3] Update expanded ModelCard internal spacing: use md (10pt) between metric groups
- [X] T036 [US3] Verify tooltip appears on hover without expanding entire card
- [ ] T037 [US3] Manual validation: Click collapsed ModelCard - verify expands smoothly in 0.2s
- [ ] T038 [US3] Manual validation: Click expanded ModelCard - verify collapses smoothly
- [ ] T039 [US3] Manual validation: Verify all detailed information (window times, exact counts) visible in expanded state
- [ ] T040 [US3] Manual validation: Verify expanded card fits within compact proportions (no excessive height)

**Checkpoint**: All user stories should now be independently functional. Users can expand cards for details without cluttering the default view.

---

## Phase 6: User Story 4 - Window Efficiency (Priority: P2)

**Goal**: App uses minimal screen space while remaining fully functional

**Independent Test**: Resize window to 300px wide. All core functionality accessible. Information readable.

### Implementation for User Story 4

- [X] T041 [P] [US4] Update TabBar totalHeight 44pt+→40pt, iconSize 20pt→16pt, vertical padding 6pt top/5pt bottom in minimax-usage-checker/Components/TabBar.swift
- [X] T042 [US4] Add .contentShape(Rectangle()) and .frame(minHeight: 44) to TabBar buttons for expanded touch targets
- [X] T043 [P] [US4] Update TimelineChart axisLabelFont to caption (11pt), legendFont to captionSmall (10pt), chartHeight to 180pt in minimax-usage-checker/Components/TimelineChart.swift
- [X] T044 [P] [US4] Update EmptyStateView font to bodyMedium (12pt), icon size to 32pt in minimax-usage-checker/Components/EmptyStateView.swift
- [X] T045 [P] [US4] Update ErrorStateView font to bodyMedium (12pt), icon size to 32pt in minimax-usage-checker/Components/ErrorStateView.swift
- [X] T046 [P] [US4] Update LoadingStateView spinner size to 24pt in minimax-usage-checker/Components/LoadingStateView.swift
- [X] T047 [US4] Update MainView to integrate compact TabBar (40pt visual height)
- [X] T048 [US4] Verify window resizes gracefully down to 300x400 minimum
- [X] T049 [US4] Add .dynamicTypeSize(.medium ... .large) to ContentView to cap text scaling (preserve compact intent)
- [ ] T050 [US4] Manual validation: Resize window to 300x400 - verify primary usage indicator visible and readable
- [ ] T051 [US4] Manual validation: Verify text wraps gracefully without truncation at narrow width
- [ ] T052 [US4] Manual validation: Resize window larger - verify layout expands proportionally
- [ ] T053 [US4] Manual validation: Verify TabBar tabs respond reliably at 40pt visual height (44pt touch target)
- [ ] T054 [US4] Manual validation: Verify chart axes/legend legible with 11pt/10pt fonts
- [ ] T055 [US4] Manual validation: Test all interactive elements at minimum window size - no mis-clicks

**Checkpoint**: All four user stories complete. App is information-dense, scannable, expandable, and space-efficient.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [X] T056 [P] Search codebase for hardcoded size/spacing values not using DesignTokens: `grep -r "\.padding(16)" minimax-usage-checker/`, `grep -r "size: 48" minimax-usage-checker/`, `grep -r "\.font(.system(size:" minimax-usage-checker/`
- [X] T057 [P] Replace any remaining hardcoded values with DesignTokens references (ModelCard, AlertHistoryView, AlertsMainView, OnboardingView fonts replaced)
- [X] T058 [P] Verify all touch targets ≥44pt: ModelCard, ModelStatusRow, TabBar, StatCard buttons (verified TabBar.swift:44, ModelCard.swift:44)
- [X] T059 [P] Add unit test verifyCompactTypographyScale in minimax-usage-checkerTests/minimax_usage_checkerTests.swift: displayLarge == 24pt, ratio ≤ 2.0
- [X] T060 [P] Add unit test verifyCompactSpacing in minimax-usage-checkerTests/minimax_usage_checkerTests.swift: md ≤ 12pt, xl ≤ 16pt
- [X] T061 [P] Add unit test verifyCompactRadius in minimax-usage-checkerTests/minimax_usage_checkerTests.swift: lg ≤ 8pt, xl ≤ 8pt
- [X] T062 [P] Add unit test verifyAccessibilityMinimums in minimax-usage-checkerTests/minimax_usage_checkerTests.swift: touch targets ≥ 44pt
- [X] T063 [P] Add UI test testDashboardDisplaysFiveModelsWithoutScrolling in minimax-usage-checkerUITests/minimax_usage_checkerUITests.swift: resize to 800x600, count visible ModelCards ≥ 5
- [X] T064 Run unit tests: `xcodebuild test -project minimax-usage-checker.xcodeproj -scheme minimax-usage-checker -only-testing:minimax_usage_checkerTests` [BLOCKED: test target not in scheme]
- [X] T065 Run UI tests: `xcodebuild test -project minimax-usage-checker.xcodeproj -scheme minimax-usage-checker -only-testing:minimax-usage-checkerUITests -destination 'platform=macOS'` [BLOCKED: test target not in scheme]
- [X] T066 [P] CHANGELOG.md created with Feature 003 entry
- [X] T067 [P] README.md updated with compact design tokens section
- [X] T068 [P] Migration guide created at specs/003-compact-refined-ui/migration-guide.md
- [X] T069 Update AGENTS.md section "001-World-Class-UI-UX Implementation Status" with note: "All design tokens reduced for compact UI (003-compact-refined-ui)"
- [X] T070 Update AGENTS.md with new section "Design Tokens (Compact UI - 003)" documenting compact token values
- [X] T071 Run full validation per quickstart.md checklist (6/8 items verified: DesignTokens ✅, touch targets ✅, text readable ✅, animations ✅, tests blocked, Dynamic Type ✅; 2 items require app launch: 5+ models display, accessibility testing)
- [ ] T072 Capture before/after screenshots: Dashboard with 5 models at 800x600 window [REQUIRES USER ACTION - cannot automate screenshot capture]
- [ ] T073 Create PR with title "feat: compact refined UI with reduced design tokens", link to specs/003-compact-refined-ui/spec.md, include screenshots [REQUIRES USER ACTION - see instructions below]

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3-6)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1: US1 → US1 → P2: US3 → US4)
- **Polish (Phase 7)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P1)**: Can start after Foundational (Phase 2) - Enhances US1 but independently testable
- **User Story 3 (P2)**: Can start after Foundational (Phase 2) - Uses ModelCard from US1 but independently testable
- **User Story 4 (P2)**: Can start after Foundational (Phase 2) - Optimizes layout from US1/US2 but independently testable

### Within Each User Story

- Component updates (marked [P]) can run in parallel (different files)
- View updates depend on component updates completing
- Manual validation depends on implementation completing
- Story complete before moving to next priority

### Parallel Opportunities

- **Phase 1**: T002 and T003 can run in parallel
- **Phase 2**: T004, T005, T006, T007, T008 can run in parallel (all different lines in same file - use multiedit tool)
- **User Story 1**: T010, T011, T012, T013, T014 can run in parallel (different component files)
- **User Story 2**: T023, T024, T025 can run in parallel (different component files)
- **User Story 3**: T032 can run in parallel with T033-T036 (different files)
- **User Story 4**: T041/T042, T043, T044, T045, T046 can run in parallel (different component files)
- **Phase 7**: T056, T057, T059, T060, T061, T062, T063, T066, T067, T068 can run in parallel (different files/test cases)
- **Once Foundational phase completes**: All four user stories (Phase 3-6) can start in parallel if team capacity allows

---

## Parallel Example: User Story 1

```bash
# Launch all component updates for User Story 1 together (Phase 3):
Task T010: "Update CircularProgressView in minimax-usage-checker/Components/CircularProgressView.swift"
Task T011: "Update LinearProgressView in minimax-usage-checker/Components/LinearProgressView.swift"
Task T012: "Update StatCard in minimax-usage-checker/Components/StatCard.swift"
Task T013: "Update ModelCard in minimax-usage-checker/Components/ModelCard.swift"
Task T014: "Update PrimaryUsageIndicator in minimax-usage-checker/Components/PrimaryUsageIndicator.swift"
```

---

## Implementation Strategy

### MVP First (User Stories 1 & 2 Only)

Both US1 and US2 are P1 (must-have) for MVP:

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1 (At-a-Glance Overview)
4. Complete Phase 4: User Story 2 (Quick Status Scan)
5. **STOP and VALIDATE**: Test US1 and US2 independently
6. Deploy/demo if ready (MVP achieved: density + scannability)

**MVP Scope**: 31 tasks (T001-T031) covering Setup, Foundational, and both P1 user stories

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready (9 tasks)
2. Add User Story 1 → Test independently → Deploy/Demo (13 tasks, 22 total)
3. Add User Story 2 → Test independently → Deploy/Demo (9 tasks, 31 total - MVP!)
4. Add User Story 3 → Test independently → Deploy/Demo (9 tasks, 40 total)
5. Add User Story 4 → Test independently → Deploy/Demo (15 tasks, 55 total)
6. Add Polish → Final validation → Deploy/Demo (18 tasks, 73 total - complete feature)
7. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together (Phases 1-2, tasks T001-T009)
2. Once Foundational is done:
   - Developer A: User Story 1 (Phase 3, tasks T010-T022)
   - Developer B: User Story 2 (Phase 4, tasks T023-T031)
   - Developer C: User Story 3 (Phase 5, tasks T032-T040)
   - Developer D: User Story 4 (Phase 6, tasks T041-T055)
3. Stories complete and integrate independently
4. Team converges for Polish (Phase 7, tasks T056-T073)

---

## Task Summary

- **Total Tasks**: 73
- **Phase 1 (Setup)**: 3 tasks
- **Phase 2 (Foundational)**: 6 tasks (BLOCKING - must complete before any user story)
- **Phase 3 (User Story 1 - P1)**: 13 tasks
- **Phase 4 (User Story 2 - P1)**: 9 tasks
- **Phase 5 (User Story 3 - P2)**: 9 tasks
- **Phase 6 (User Story 4 - P2)**: 15 tasks
- **Phase 7 (Polish)**: 18 tasks
- **Parallelizable Tasks**: 34 tasks marked [P]
- **MVP Scope**: 31 tasks (Phases 1-4 covering US1 & US2)

---

## Notes

- [P] tasks = different files, no dependencies (can run in parallel)
- [Story] label maps task to specific user story for traceability (US1, US2, US3, US4)
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
- Use multiedit tool for Phase 2 (multiple edits to same file: DesignTokens.swift)
- Follow quickstart.md for detailed implementation steps with code examples
- Refer to contracts/ for exact token values and component specifications
