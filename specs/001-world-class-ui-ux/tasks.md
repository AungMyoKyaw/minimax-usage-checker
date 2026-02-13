# Tasks: World-Class UI/UX Redesign

**Input**: Design documents from `/specs/001-world-class-ui-ux/`
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅, contracts/ ✅

**Tests**: Tests are OPTIONAL for this UI/UX redesign. Focus is on component implementation with visual verification via Xcode previews.

**Organization**: Tasks grouped by user story for independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1-US7)
- Include exact file paths in descriptions

## Path Conventions

- **Project Root**: `minimax-usage-checker/`
- **Design System**: `minimax-usage-checker/DesignSystem/`
- **Components**: `minimax-usage-checker/Components/`
- **Views**: `minimax-usage-checker/Views/`
- **Assets**: `minimax-usage-checker/Assets.xcassets/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project structure and design system foundation

- [ ] T001 Create DesignSystem directory at `minimax-usage-checker/DesignSystem/`
- [ ] T002 Create Components directory at `minimax-usage-checker/Components/`
- [ ] T003 Create Views directory at `minimax-usage-checker/Views/`
- [ ] T004 [P] Create UsageSafe color set in `Assets.xcassets/Colors/UsageSafe.colorset/` with Light #34C759, Dark #30D158
- [ ] T005 [P] Create UsageWarning color set in `Assets.xcassets/Colors/UsageWarning.colorset/` with Light #FF9500, Dark #FF9F0A
- [ ] T006 [P] Create UsageCritical color set in `Assets.xcassets/Colors/UsageCritical.colorset/` with Light #FF3B30, Dark #FF453A
- [ ] T007 [P] Create SurfacePrimary color set in `Assets.xcassets/Colors/SurfacePrimary.colorset/` with Light #FFFFFF, Dark #1C1C1E
- [ ] T008 [P] Create SurfaceSecondary color set in `Assets.xcassets/Colors/SurfaceSecondary.colorset/` with Light #F2F2F7, Dark #2C2C2E
- [ ] T009 [P] Create SurfaceTertiary color set in `Assets.xcassets/Colors/SurfaceTertiary.colorset/` with Light #E5E5EA, Dark #3A3A3C
- [ ] T010 [P] Create BorderSubtle color set in `Assets.xcassets/Colors/BorderSubtle.colorset/` with Light #E5E5EA, Dark #38383A
- [ ] T011 [P] Create BorderEmphasis color set in `Assets.xcassets/Colors/BorderEmphasis.colorset/` with Light #C7C7CC, Dark #48484A

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core design system that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T012 Create DesignTokens.swift in `DesignSystem/DesignTokens.swift` with Colors, Spacing, Radius, Typography enums
- [ ] T013 Create Animations.swift in `DesignSystem/Animations.swift` with appTransition, appSpring, appSubtle, appValue extensions
- [ ] T014 Create UsageStatus.swift in `DesignSystem/UsageStatus.swift` with safe/warning/critical enum and color mapping
- [ ] T015 Create EmptyStateType.swift in `DesignSystem/EmptyStateType.swift` with noAPIKey, noHistory, noModels, firstTimeUser cases
- [ ] T016 Create ErrorStateType.swift in `DesignSystem/ErrorStateType.swift` with networkError, invalidAPIKey, rateLimited, serviceUnavailable cases

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Instant Comprehension (Priority: P1) 🎯 MVP

**Goal**: Users immediately understand the app's purpose and their usage status within 3 seconds

**Independent Test**: Show app to 5 first-time users for 5 seconds, ask: (1) what it does, (2) current usage, (3) what to click next. Success = 80% accuracy.

### Implementation for User Story 1

- [ ] T017 [P] [US1] Create CircularProgressView.swift in `Components/CircularProgressView.swift` with progress, status, size parameters
- [ ] T018 [P] [US1] Create LinearProgressView.swift in `Components/LinearProgressView.swift` with progress, status, height parameters
- [ ] T019 [US1] Add animation support to CircularProgressView with spring animation on progress change
- [ ] T020 [US1] Add accessibility labels to CircularProgressView (accessibilityLabel: "Usage progress", accessibilityValue: "X percent used")
- [ ] T021 [US1] Create PrimaryUsageIndicator.swift in `Components/PrimaryUsageIndicator.swift` combining CircularProgressView with model name and remaining time
- [ ] T022 [US1] Ensure PrimaryUsageIndicator dominates dashboard visually per FR-011

**Checkpoint**: Primary usage indicator complete - users can instantly see their usage status

---

## Phase 4: User Story 2 - Frictionless API Key Entry (Priority: P1)

**Goal**: Users enter API key with zero confusion, zero errors, and immediate visual feedback

**Independent Test**: Time 10 users entering API key. Success = <10 seconds, 0% error rate, effort ≤2.

### Implementation for User Story 2

- [ ] T023 [US2] Create OnboardingView.swift in `Views/OnboardingView.swift` with brand header, secure input, and action button
- [ ] T024 [US2] Add gradient circle background with brain.head.profile icon to OnboardingView
- [ ] T025 [US2] Implement SecureField with DesignTokens styling and focus state
- [ ] T026 [US2] Add button disabled state when apiKey.isEmpty with visual subdued styling
- [ ] T027 [US2] Add shadow effect to action button using Color.accentColor.opacity(0.3)
- [ ] T028 [US2] Add trust message below button: "Your API key is stored locally and never leaves your device"
- [ ] T029 [US2] Implement auto-focus on SecureField when view appears
- [ ] T030 [US2] Add transition animation from OnboardingView to main content on successful API key entry

**Checkpoint**: Onboarding flow complete - new users can enter API key frictionlessly

---

## Phase 5: User Story 3 - At-a-Glance Usage Intelligence (Priority: P1)

**Goal**: Users instantly understand usage state with perfect information density

**Independent Test**: Time users to answer "What's your current usage?" when app visible but not focused. Success = <2 seconds with 100% accuracy.

### Implementation for User Story 3

- [ ] T031 [P] [US3] Create StatCard.swift in `Components/StatCard.swift` with title, value, subtitle, icon, status parameters
- [ ] T032 [US3] Add hover state to StatCard with scaleEffect(1.02) and shadow increase
- [ ] T033 [US3] Add accessibility element combining title, value, subtitle for StatCard
- [ ] T034 [US3] Create StatsOverview.swift in `Components/StatsOverview.swift` with 4 StatCards (Total Used, Remaining, Avg Usage, Models)
- [ ] T035 [P] [US3] Create ModelStatusRow.swift in `Components/ModelStatusRow.swift` showing model name, window range, remaining time with status color dot
- [ ] T036 [US3] Implement visual hierarchy in ModelStatusRow prioritizing model closest to limit by size/position/color intensity
- [ ] T037 [US3] Create ModelStatusList.swift in `Components/ModelStatusList.swift` as container for multiple ModelStatusRows
- [ ] T038 [US3] Create DashboardView.swift in `Views/DashboardView.swift` combining PrimaryUsageIndicator, StatsOverview, ModelStatusList
- [ ] T039 [US3] Add ScrollView with DesignTokens.Spacing.lg padding to DashboardView
- [ ] T040 [US3] Set DashboardView background to DesignTokens.Colors.surfaceTertiary.opacity(0.5)

**Checkpoint**: Dashboard complete - users can see all usage information at a glance

---

## Phase 6: User Story 4 - Meaningful History Exploration (Priority: P2)

**Goal**: Users explore usage history to understand patterns and trends

**Independent Test**: Users answer "Which day had most API calls?" and "Is usage increasing or decreasing?" Success = 90% accuracy in <15 seconds.

### Implementation for User Story 4

- [ ] T041 [P] [US4] Create TimeRangePicker.swift in `Components/TimeRangePicker.swift` with Today/Week/Month/All segments
- [ ] T042 [US4] Add selected state styling to TimeRangePicker with accentColor background and white text
- [ ] T043 [US4] Add spring animation on TimeRangePicker segment selection
- [ ] T044 [P] [US4] Create TimelineChart.swift in `Components/TimelineChart.swift` using Charts framework for bar visualization
- [ ] T045 [US4] Add gradient fill to TimelineChart bars (accentColor to 60% opacity)
- [ ] T046 [US4] Implement staggered entrance animation for TimelineChart bars
- [ ] T047 [P] [US4] Create TooltipView.swift in `Components/TooltipView.swift` with title, value, optional detail
- [ ] T048 [US4] Position TooltipView to avoid screen edges with auto-positioning logic
- [ ] T049 [US4] Create HistoryView.swift in `Views/HistoryView.swift` with TimeRangePicker and TimelineChart
- [ ] T050 [US4] Update existing HistoryList to use new design tokens for consistent styling
- [ ] T051 [US4] Update existing HistoryRow to use DesignTokens.Colors.surfacePrimary and new typography

**Checkpoint**: History view complete - users can explore usage patterns over time

---

## Phase 7: User Story 5 - Effortless Model Deep-Dive (Priority: P2)

**Goal**: Users seamlessly transition from overview to detailed model information

**Independent Test**: Users find "How much time remains before abab6.5s-chat resets?" Success = 95% accuracy in <5 seconds.

### Implementation for User Story 5

- [ ] T052 [US5] Create ModelCard.swift in `Components/ModelCard.swift` with collapsed and expanded states
- [ ] T053 [US5] Add model name, usage progress bar, remaining time to collapsed ModelCard state
- [ ] T054 [US5] Implement expand/collapse spring animation on ModelCard tap
- [ ] T055 [US5] Add window timeline visualization to expanded ModelCard state showing current position in cycle
- [ ] T056 [US5] Add shadow-md when ModelCard is expanded for depth indication
- [ ] T057 [US5] Create UsageView.swift in `Views/UsageView.swift` with LazyVStack of ModelCards
- [ ] T058 [US5] Add spring animation for ModelCard insertions/removals in UsageView
- [ ] T059 [US5] Implement press feedback on ModelCard tap using .buttonStyle(.plain)

**Checkpoint**: Model detail view complete - users can drill into specific model information

---

## Phase 8: User Story 6 - Delightful Micro-Interactions (Priority: P3)

**Goal**: Every interaction includes thoughtful, purposeful animation

**Independent Test**: Users rate 10 common interactions on 1-5 scale. Success = average ≥4.5, no rating <4.

### Implementation for User Story 6

- [ ] T060 [P] [US6] Create TabBar.swift in `Components/TabBar.swift` replacing inline TabPicker with proper component
- [ ] T061 [US6] Add tab transition animation (scale 0.98 + opacity) for TabBar switches
- [ ] T062 [US6] Implement refresh button transformation to ProgressView spinner when loading
- [ ] T063 [US6] Add value animation for number transitions (used count, remaining count, percentage)
- [ ] T064 [US6] Implement hover states for all interactive elements with DesignTokens.Radius.sm corner radius
- [ ] T065 [US6] Add focus ring animation for keyboard navigation (2px accentColor stroke)
- [ ] T066 [US6] Implement skeleton loading states for StatCards during initial data load
- [ ] T067 [US6] Add Reduce Motion support to all animations via @Environment(\.accessibilityReduceMotion)

**Checkpoint**: All micro-interactions polished - app feels responsive and delightful

---

## Phase 9: User Story 7 - Graceful Error & Empty States (Priority: P3)

**Goal**: Beautiful, informative states for errors and empty content

**Independent Test**: Simulate 5 error/empty conditions, measure sentiment before/after. Success = neutral/positive shift in 80%.

### Implementation for User Story 7

- [ ] T068 [P] [US7] Create EmptyStateView.swift in `Components/EmptyStateView.swift` with icon, title, message, optional action
- [ ] T069 [US7] Add gradient circle background and pulse animation to EmptyStateView icon
- [ ] T070 [US7] Create ErrorStateView.swift in `Components/ErrorStateView.swift` with icon, title, message, retry action
- [ ] T071 [US7] Add single clear action button to ErrorStateView with primary button style
- [ ] T072 [US7] Create LoadingStateView.swift in `Components/LoadingStateView.swift` with skeleton screens
- [ ] T073 [US7] Add shimmer animation to LoadingStateView skeleton elements
- [ ] T074 [US7] Integrate EmptyStateView into HistoryView when snapshots.isEmpty
- [ ] T075 [US7] Integrate ErrorStateView into DashboardView for network/API failures
- [ ] T076 [US7] Add friendly human language to all error messages (no technical jargon)

**Checkpoint**: All edge cases handled beautifully

---

## Phase 10: Polish & Cross-Cutting Concerns

**Purpose**: Final integration and refinements

- [ ] T077 [P] Update ContentView.swift to use new view structure with OnboardingView, TabBar, and main views
- [ ] T078 Create MainView.swift in `Views/MainView.swift` as container for TabBar and DashboardView/UsageView/HistoryView
- [ ] T079 Add NavigationStack to ContentView with logout button in toolbar
- [ ] T080 [P] Verify all components respect @Environment(\.accessibilityReduceMotion)
- [ ] T081 [P] Verify all interactive elements have accessibility labels
- [ ] T082 [P] Verify minimum 4.5:1 contrast ratio for all text elements
- [ ] T083 Run full app in light mode and verify all colors display correctly
- [ ] T084 Run full app in dark mode and verify all colors display correctly
- [ ] T085 Verify window resizing from 600x400 to maximum maintains layout integrity
- [ ] T086 Test keyboard navigation through all interactive elements
- [ ] T087 Run quickstart.md validation scenarios
- [ ] T088 Final code cleanup and comment removal

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3-9)**: All depend on Foundational phase completion
  - US1, US2, US3 (P1) can proceed in parallel after Foundational
  - US4, US5 (P2) can proceed in parallel after Foundational
  - US6, US7 (P3) can proceed in parallel after Foundational
- **Polish (Phase 10)**: Depends on all desired user stories being complete

### User Story Dependencies

- **US1 (P1)**: No dependencies - creates core progress components
- **US2 (P1)**: No dependencies - creates onboarding flow
- **US3 (P1)**: Depends on US1 components (CircularProgressView, PrimaryUsageIndicator)
- **US4 (P2)**: No dependencies - creates history visualization
- **US5 (P2)**: No dependencies - creates model detail views
- **US6 (P3)**: Can integrate with existing components - adds polish
- **US7 (P3)**: No dependencies - creates state views

### Parallel Opportunities

Within each user story phase, tasks marked [P] can run in parallel:
- **Phase 1**: T004-T011 (all color assets) can run in parallel
- **Phase 3**: T017, T018 (progress views) can run in parallel
- **Phase 5**: T031, T035 (StatCard, ModelStatusRow) can run in parallel
- **Phase 6**: T041, T044, T047 (TimeRangePicker, TimelineChart, TooltipView) can run in parallel
- **Phase 10**: T080-T082 (accessibility verification) can run in parallel

---

## Parallel Example: Phase 5 (User Story 3)

```bash
# Launch in parallel (different files):
Task: "Create StatCard.swift in Components/StatCard.swift"
Task: "Create ModelStatusRow.swift in Components/ModelStatusRow.swift"

# Then sequentially:
Task: "Add hover state to StatCard"
Task: "Create StatsOverview.swift"
```

---

## Implementation Strategy

### MVP First (User Stories 1, 2, 3 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1 (Instant Comprehension)
4. Complete Phase 4: User Story 2 (API Key Entry)
5. Complete Phase 5: User Story 3 (At-a-Glance Intelligence)
6. **STOP and VALIDATE**: Test all P1 stories independently
7. Deploy/demo MVP

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add US1, US2, US3 → Core dashboard functional → **MVP!**
3. Add US4, US5 → History and details functional
4. Add US6, US7 → Polish and error handling
5. Add Phase 10 → Production ready

---

## Summary

| Metric | Value |
|--------|-------|
| **Total Tasks** | 88 |
| **Setup Tasks** | 11 |
| **Foundational Tasks** | 5 |
| **US1 Tasks** | 6 |
| **US2 Tasks** | 8 |
| **US3 Tasks** | 10 |
| **US4 Tasks** | 11 |
| **US5 Tasks** | 8 |
| **US6 Tasks** | 8 |
| **US7 Tasks** | 9 |
| **Polish Tasks** | 12 |
| **Parallel Opportunities** | 28 tasks marked [P] |
| **MVP Scope** | Phases 1-5 (Tasks T001-T040) |
