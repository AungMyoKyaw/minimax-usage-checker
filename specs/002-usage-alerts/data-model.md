# Data Model: Usage Alerts

## Entities

### AlertSettings

Global and per-model alert configuration.

| Field | Type | Validation | Description |
|-------|------|------------|-------------|
| globalWarningThreshold | Double | 10-99% | Usage % that triggers warning |
| globalCriticalThreshold | Double | 5-95% | Usage % that triggers critical |
| perModelOverrides | [String: ModelAlertSettings] | Optional | Per-model threshold overrides |
| enabledModels | Set<String> | Optional | Models with alerts enabled |
| isSnoozed | Bool | Default: false | Global snooze state |
| snoozeEndTime | Date? | Optional | When snooze ends |
| customWarningMessage | String? | Optional | Custom warning template |
| customCriticalMessage | String? | Optional | Custom critical template |

### ModelAlertSettings

Per-model threshold override.

| Field | Type | Validation | Description |
|-------|------|------------|-------------|
| warningThreshold | Double | 10-99% | Model-specific warning |
| criticalThreshold | Double | 5-95% | Model-specific critical |
| isEnabled | Bool | Default: true | Per-model alert toggle |

### AlertHistoryEntry

Single alert record.

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | Unique identifier |
| modelName | String | Model that triggered alert |
| usagePercentage | Double | Usage at time of alert |
| alertType | AlertType | warning or critical |
| timestamp | Date | When alert was triggered |

### AlertType

```swift
enum AlertType: String, Codable {
    case warning
    case critical
}
```

## Relationships

```
AlertSettings (1) ─── (*) ModelAlertSettings
AlertSettings (1) ─── (*) AlertHistoryEntry
```

## State Transitions

### Snooze State Machine
```
NOT_SNOOZED ──snooze()──> SNOOZED
SNOOZED ──time expires──> NOT_SNOOZED
SNOOZED ──unsnooze()──> NOT_SNOOZED
```

### Alert History
- New alerts added to front of list
- Auto-prune when > 100 entries (remove oldest)
- Clear history removes all entries

## Persistence

- **UserDefaults Key**: `alert_settings` (JSON encoded AlertSettings)
- **UserDefaults Key**: `alert_history` (JSON encoded [AlertHistoryEntry])
