# Contracts: Usage Alerts

## AlertSettingsManager (Swift)

Manages alert configuration and persistence.

```swift
protocol AlertSettingsManaging {
    // Getters
    var settings: AlertSettings { get }
    
    // Global thresholds
    func setGlobalWarningThreshold(_ value: Double) throws
    func setGlobalCriticalThreshold(_ value: Double) throws
    
    // Per-model settings
    func setPerModelThreshold(modelName: String, warning: Double, critical: Double) throws
    func setModelEnabled(_ enabled: Bool, modelName: String) throws
    func removePerModelOverride(modelName: String) throws
    
    // Snooze
    func snooze(duration: SnoozeDuration) throws
    func unsnooze() -> Bool  // Returns true if was snoozed
    
    // Custom messages
    func setCustomWarningMessage(_ message: String?) throws
    func setCustomCriticalMessage(_ message: String?) throws
    
    // Reset
    func resetToDefaults() throws
}

enum SnoozeDuration: CaseIterable {
    case fifteenMinutes
    case oneHour
    case fourHours
    case twentyFourHours
    
    var seconds: TimeInterval {
        switch self {
        case .fifteenMinutes: return 15 * 60
        case .oneHour: return 60 * 60
        case .fourHours: return 4 * 60 * 60
        case .twentyFourHours: return 24 * 60 * 60
        }
    }
}
```

## AlertHistoryManager (Swift)

Manages alert history storage and retrieval.

```swift
protocol AlertHistoryManaging {
    var history: [AlertHistoryEntry] { get }
    
    func addEntry(_ entry: AlertHistoryEntry) throws
    func clearHistory() throws
    
    // Computed
    var isAtCapacity: Bool { get }
}
```

## NotificationManager Extension

Existing interface remains, new methods added:

```swift
extension NotificationManager {
    // New methods for configurable alerts
    func checkAndNotifyWithSettings(
        modelRemains: [ModelRemain],
        settings: AlertSettings
    )
    
    // Snooze check
    func shouldNotify(settings: AlertSettings) -> Bool
}
```

## Validation Rules

| Rule | Error |
|------|-------|
| Warning threshold < 10% | ValidationError.warningTooLow |
| Warning threshold > 99% | ValidationError.warningTooHigh |
| Critical threshold < 5% | ValidationError.criticalTooLow |
| Critical threshold > 95% | ValidationError.criticalTooHigh |
| Warning ≤ Critical | ValidationError.warningMustExceedCritical |
| Model name not found | ValidationError.modelNotFound |

```swift
enum ValidationError: LocalizedError {
    case warningTooLow
    case warningTooHigh
    case criticalTooLow
    case criticalTooHigh
    case warningMustExceedCritical
    case modelNotFound
    
    var errorDescription: String? {
        switch self {
        case .warningTooLow: return "Warning threshold must be at least 10%"
        case .warningTooHigh: return "Warning threshold must be at most 99%"
        case .criticalTooLow: return "Critical threshold must be at least 5%"
        case .criticalTooHigh: return "Critical threshold must be at most 95%"
        case .warningMustExceedCritical: return "Warning threshold must be greater than critical threshold"
        case .modelNotFound: return "Model not found"
        }
    }
}
```
