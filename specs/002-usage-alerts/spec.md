# Feature Specification: Usage Alerts

**Feature Branch**: `002-usage-alerts`  
**Created**: 2026-02-14  
**Status**: Draft  
**Input**: User description: "Usage alerts"

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value.
  
  Assign priorities (P1, P2, P3, etc.) to each story, where P1 is the most critical.
  Think of each story as a standalone slice of functionality that can be:
  - Developed independently
  - Tested independently
  - Deployed independently
  - Demonstrated to users independently
-->

### User Story 1 - Configure Alert Thresholds (Priority: P1)

User wants to set custom usage thresholds for when they receive alerts, rather than using fixed defaults.

**Why this priority**: Different users have different usage patterns and risk tolerances. Some want early warnings at 70%, others only want critical alerts at 95%.

**Independent Test**: Can be tested by opening settings, changing threshold values, and verifying the new values persist after app restart.

**Acceptance Scenarios**:

1. **Given** the user has never configured thresholds, **When** they open the alerts settings, **Then** they see default values (Warning: 85%, Critical: 95%)
2. **Given** the user has configured custom thresholds, **When** they open alerts settings, **Then** they see their saved custom values
3. **Given** the user sets Warning threshold to 80%, **When** usage reaches 80%, **Then** they receive a warning notification
4. **Given** the user sets Critical threshold to 90%, **When** usage reaches 90%, **Then** they receive a critical notification

---

### User Story 2 - Per-Model Alert Configuration (Priority: P2)

User wants to set different alert thresholds for different AI models, since some models are more critical than others.

**Why this priority**: Users may use different models for different purposes - production vs testing - and want differentiated alerting.

**Independent Test**: Can be tested by setting a 70% threshold for one model and 90% for another, then verifying each triggers at its respective level.

**Acceptance Scenarios**:

1. **Given** the user has multiple models, **When** they view alert settings, **Then** they see a list of all available models with their individual threshold settings
2. **Given** the user sets a custom threshold for "abab6.5s-chat", **When** usage reaches that threshold, **Then** they receive a notification for that specific model
3. **Given** the user enables alerts for one model but disables for another, **Then** they only receive notifications for the enabled model

---

### User Story 3 - Alert History (Priority: P3)

User wants to see a history of past alerts to track when they've received warnings and what actions they took.

**Why this priority**: Users want to review alert patterns over time to understand their usage trends and anticipate when they need to top up credits.

**Independent Test**: Can be tested by triggering several alerts, then viewing the alert history and verifying all alerts are listed with timestamps.

**Acceptance Scenarios**:

1. **Given** the user has received alerts, **When** they open alert history, **Then** they see a chronological list of all past alerts with date, time, model name, and alert type
2. **Given** the user wants to clear old alerts, **When** they click "Clear History", **Then** all past alerts are removed from the list
3. **Given** the alert history reaches 100 entries, **Then** the oldest alerts are automatically pruned to maintain performance

---

### User Story 4 - Snooze Alerts (Priority: P3)

User wants to temporarily pause alerts for a specific duration so they aren't bombarded during active work sessions.

**Why this priority**: Users may be actively using the API and don't need repeated notifications during that time.

**Independent Test**: Can be tested by snoozing alerts for 1 hour, then verifying no notifications appear during that period, but notifications resume after the snooze ends.

**Acceptance Scenarios**:

1. **Given** the user receives an alert, **When** they click "Snooze", **Then** they can select a snooze duration (15min, 1hr, 4hr, 24hr)
2. **Given** alerts are snoozed, **When** usage crosses threshold, **Then** no notification is sent
3. **Given** snooze period has ended, **When** usage still exceeds threshold, **Then** normal notifications resume

---

### User Story 5 - Custom Alert Messages (Priority: P4)

User wants to customize the notification message template to include information relevant to their workflow.

**Why this priority**: Power users want personalized alerts that fit their team's terminology and response workflow.

**Independent Test**: Can be tested by setting a custom message template, then triggering an alert and verifying the custom message appears in the notification.

**Acceptance Scenarios**:

1. **Given** the user edits their alert message template, **When** an alert is triggered, **Then** the notification uses their custom message with model name and percentage filled in
2. **Given** the user resets to default messages, **When** an alert triggers, **Then** the original default message is used

---

### Edge Cases

- What happens when the user sets Warning threshold higher than Critical threshold? (Should validate and show error)
- How does system handle when API is unreachable during alert check? (Skip alert, retry next cycle)
- What happens when user has 0 remaining credits? (Send immediate critical alert regardless of threshold)
- How are alerts handled when app is not running? (Check on app launch)
- What if user has 50+ models? (Paginate the model list in settings)

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST allow users to configure global Warning threshold (10%-99%)
- **FR-002**: System MUST allow users to configure global Critical threshold (5%-95%)
- **FR-003**: System MUST allow users to set per-model threshold overrides
- **FR-004**: System MUST allow users to enable/disable alerts per model
- **FR-005**: System MUST persist all alert settings in UserDefaults
- **FR-006**: System MUST send Warning notification when any model's usage crosses Warning threshold
- **FR-007**: System MUST send Critical notification when any model's usage crosses Critical threshold
- **FR-008**: System MUST display alert history with model name, timestamp, and alert type
- **FR-009**: System MUST allow users to clear alert history
- **FR-010**: System MUST support snooze functionality with configurable duration
- **FR-011**: System MUST auto-prune alert history when exceeding 100 entries
- **FR-012**: System MUST validate that Warning threshold is greater than Critical threshold
- **FR-013**: System MUST allow users to customize notification message templates

### Key Entities *(include if data involved)*

- **AlertSettings**: Stores user's threshold preferences, per-model overrides, and notification preferences
- **AlertHistory**: Record of past alerts including timestamp, model, usage percentage, alert type
- **SnoozeState**: Tracks active snooze timer and which models are snoozed

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can configure and save custom thresholds in under 30 seconds
- **SC-002**: 95% of configured threshold crossings result in notifications within 1 minute
- **SC-003**: Alert settings persist correctly across app restarts
- **SC-004**: Alert history displays at least the last 100 alerts with accurate timestamps
- **SC-005**: Snooze functionality prevents all notifications during the snooze period
- **SC-006**: Per-model settings correctly override global settings for each model

## Assumptions

- Users have already configured their API key (existing onboarding flow)
- The app uses local notifications (not push notifications to devices)
- Alert checking happens on the same schedule as usage data refresh (every 30 seconds by default)
- Maximum 100 models will be monitored at once
- Snooze is model-agnostic (snoozes all alerts, not per-model)

