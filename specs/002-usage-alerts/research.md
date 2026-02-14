# Research: Usage Alerts Feature

**Date**: 2026-02-14
**Feature**: 002-usage-alerts

## Technical Approach

### Decision: Use UserDefaults for Alert Settings
**Rationale**: The existing project already uses UserDefaults for API key and usage snapshots. Following the same pattern maintains consistency and simplicity.

**Alternatives considered**:
- SQLite - Overkill for simple key-value settings
- CoreData - Not needed for this scale
- File-based JSON - More error-prone than UserDefaults

### Decision: Extend Existing NotificationManager
**Rationale**: The existing NotificationManager already handles notification sending, authorization, and alert deduplication. Extending it is cleaner than creating parallel systems.

**Alternatives considered**:
- Create new AlertService class - Would duplicate notification code
- Move all to UsageViewModel - Would bloat the ViewModel

### Decision: SwiftUI Settings View for Configuration
**Rationale**: The app uses SwiftUI. A dedicated settings section for alerts follows iOS/macOS conventions.

**Alternatives considered**:
- Inline settings in main view - Would clutter existing UI
- Modal sheet - Good for focused editing, preferred approach

## Best Practices Applied

1. **UserDefaults Keys**: Prefix with `alert_` to avoid collisions with existing keys (`minimax_api_key`, `minimax_usage_snapshots`)

2. **Codable Models**: Use Codable for settings and history to enable easy JSON persistence

3. **MVVM**: Keep settings logic in dedicated managers, expose via ViewModel

4. **Error Handling**: Validate threshold values before saving (Warning > Critical)

## No Unresolved Clarifications

All technical decisions made based on:
- Existing project patterns from AGENTS.md
- SwiftUI/macOS best practices
- Feature spec requirements
