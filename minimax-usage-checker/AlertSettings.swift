import Foundation

struct AlertSettings: Codable, Equatable {
    var globalWarningThreshold: Double
    var globalCriticalThreshold: Double
    var perModelOverrides: [String: ModelAlertSettings]
    var enabledModels: [String]
    var isSnoozed: Bool
    var snoozeEndTime: Date?
    var customWarningMessage: String?
    var customCriticalMessage: String?
    
    static let defaultSettings = AlertSettings(
        globalWarningThreshold: 85.0,
        globalCriticalThreshold: 95.0,
        perModelOverrides: [:],
        enabledModels: [],
        isSnoozed: false,
        snoozeEndTime: nil,
        customWarningMessage: nil,
        customCriticalMessage: nil
    )
    
    var enabledModelsSet: Set<String> {
        Set(enabledModels)
    }
    
    var isSnoozedCurrently: Bool {
        guard isSnoozed, let endTime = snoozeEndTime else {
            return false
        }
        return Date() < endTime
    }
    
    var effectiveWarningMessage: String {
        customWarningMessage ?? "MiniMax Usage Warning: {model} only {remaining} remaining ({percent}% left)"
    }
    
    var effectiveCriticalMessage: String {
        customCriticalMessage ?? "MiniMax Credits Low!: {model} only {remaining} remaining! Time to top up."
    }
    
    enum CodingKeys: String, CodingKey {
        case globalWarningThreshold = "global_warning_threshold"
        case globalCriticalThreshold = "global_critical_threshold"
        case perModelOverrides = "per_model_overrides"
        case enabledModels = "enabled_models"
        case isSnoozed = "is_snoozed"
        case snoozeEndTime = "snooze_end_time"
        case customWarningMessage = "custom_warning_message"
        case customCriticalMessage = "custom_critical_message"
    }
}
