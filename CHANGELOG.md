# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2026-02-14

### Added - Feature 003: Compact Refined UI
- Compact design system with reduced design tokens:
  - Typography: 25% reduction (11pt-24pt scale: caption to displayLarge)
  - Spacing: 37% reduction (4pt-24pt: xs to xl)
  - Border radius: 33% reduction (4pt-10pt: sm to lg)
  - Shadows: 50% reduction (2pt-12pt blur radius)
- Expand/collapse functionality for ModelCard with smooth 0.2s spring animations
- Window minimum size enforcement (300x400) with responsive layouts
- Dynamic type size capping (.medium to .large) to preserve compact layout integrity
- Touch target accessibility (44pt minimum) across all interactive components
- Reduce motion support for all animations via `@Environment(\.accessibilityReduceMotion)`

### Changed
- Primary usage indicator: 160x160→80x80 diameter, lineWidth 12→6 (50% reduction)
- CircularProgressView defaults: 120x120→80x80 diameter, lineWidth 8→6
- LinearProgressView default height: 8→6
- All component spacing reduced for improved information density
- TabBar visual height: 44pt→40pt (touch target maintained at 44pt for accessibility)
- State view icons (EmptyStateView, ErrorStateView): 40pt→32pt
- StatCard icons: 20pt→16pt
- Animation timing: Spring response 0.35s→0.2s (43% faster)
- DashboardView padding: lg→md (reduced vertical spacing)
- HistoryView: VStack spacing lg→md, TimelineChart height 200→180
- OnboardingView: Form VStack spacing lg→md

### Fixed
- Consistent color coding across all status indicators using `UsageStatus.color`
- Font weight hierarchy enforced (semibold/medium for primary, regular for secondary)
- ModelCard touch target accessibility (minHeight 44pt maintained despite visual changes)
- TabBar touch target accessibility (minHeight 44pt maintained despite visual changes)
- Replaced all hardcoded padding/spacing/font values with DesignTokens

## [0.2.0] - 2026-02-13

### Added - Feature 002: Configurable Usage Alerts
- Configurable alert thresholds with per-model settings
- Alert history tracking (max 100 entries)
- Snooze functionality (15min, 1hr, 4hr, 24hr)
- Custom alert message templates with variable support
- Alert validation (warning > critical threshold enforcement)

### Changed
- NotificationManager extended to use configurable thresholds from AlertSettingsManager
- Settings persisted to UserDefaults (`alert_settings`, `alert_history` keys)

## [0.1.0] - 2026-02-12

### Added - Initial Release
- Native macOS application (Swift/SwiftUI)
- Real-time usage monitoring via MiniMax API
- Dashboard with usage charts (Charts framework)
- Per-model breakdown in UsageView
- Historical data tracking (max 10,000 snapshots)
- Push notifications for usage thresholds (85% warning, 95% critical)
- Auto-refresh (30s interval)
- Secure API key storage (UserDefaults, local only)

### Technical
- MVVM architecture (UsageViewModel, MiniMaxAPIService)
- App Sandbox enabled with network client access
- Target: macOS 12.0+ (Monterey)
- Frameworks: SwiftUI, Charts, Combine, UserNotifications, Foundation
