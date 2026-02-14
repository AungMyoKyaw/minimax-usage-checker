import Foundation
import Combine

@MainActor
class AlertSettingsManager: ObservableObject {
    static let shared = AlertSettingsManager()
    
    private let userDefaults = UserDefaults.standard
    private let settingsKey = "alert_settings"
    
    @Published var settings: AlertSettings {
        didSet {
            saveSettings()
        }
    }
    
    private init() {
        if let data = userDefaults.data(forKey: settingsKey),
           let decoded = try? JSONDecoder().decode(AlertSettings.self, from: data) {
            self.settings = decoded
        } else {
            self.settings = .defaultSettings
        }
    }
    
    private func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            userDefaults.set(encoded, forKey: settingsKey)
        }
    }
    
    func setGlobalWarningThreshold(_ value: Double) throws {
        try validateWarningThreshold(value)
        try validateWarningGreaterThanCritical(value, settings.globalCriticalThreshold)
        settings.globalWarningThreshold = value
    }
    
    func setGlobalCriticalThreshold(_ value: Double) throws {
        try validateCriticalThreshold(value)
        try validateWarningGreaterThanCritical(settings.globalWarningThreshold, value)
        settings.globalCriticalThreshold = value
    }
    
    func setPerModelThreshold(modelName: String, warning: Double, critical: Double) throws {
        try validateWarningThreshold(warning)
        try validateCriticalThreshold(critical)
        try validateWarningGreaterThanCritical(warning, critical)
        
        settings.perModelOverrides[modelName] = ModelAlertSettings(
            warningThreshold: warning,
            criticalThreshold: critical,
            isEnabled: true
        )
    }
    
    func setModelEnabled(_ enabled: Bool, modelName: String) {
        if var override = settings.perModelOverrides[modelName] {
            override.isEnabled = enabled
            settings.perModelOverrides[modelName] = override
        } else if !enabled {
            settings.perModelOverrides[modelName] = ModelAlertSettings(
                warningThreshold: settings.globalWarningThreshold,
                criticalThreshold: settings.globalCriticalThreshold,
                isEnabled: enabled
            )
        }
    }
    
    func removePerModelOverride(modelName: String) {
        settings.perModelOverrides.removeValue(forKey: modelName)
    }
    
    func snooze(duration: SnoozeDuration) throws {
        settings.isSnoozed = true
        settings.snoozeEndTime = Date().addingTimeInterval(duration.seconds)
    }
    
    @discardableResult
    func unsnooze() -> Bool {
        let wasSnoozed = settings.isSnoozed
        settings.isSnoozed = false
        settings.snoozeEndTime = nil
        return wasSnoozed
    }
    
    func setCustomWarningMessage(_ message: String?) throws {
        settings.customWarningMessage = message
    }
    
    func setCustomCriticalMessage(_ message: String?) throws {
        settings.customCriticalMessage = message
    }
    
    func setCustomMessages(warning: String?, critical: String?) {
        settings.customWarningMessage = warning
        settings.customCriticalMessage = critical
    }
    
    func resetToDefaults() throws {
        settings = .defaultSettings
    }
    
    func getThreshold(for modelName: String) -> (warning: Double, critical: Double) {
        if let override = settings.perModelOverrides[modelName], override.isEnabled {
            return (override.warningThreshold, override.criticalThreshold)
        }
        return (settings.globalWarningThreshold, settings.globalCriticalThreshold)
    }
    
    func isModelEnabled(_ modelName: String) -> Bool {
        if let override = settings.perModelOverrides[modelName] {
            return override.isEnabled
        }
        return true
    }
    
    private func validateWarningThreshold(_ value: Double) throws {
        if value < 10 {
            throw ValidationError.warningTooLow
        }
        if value > 99 {
            throw ValidationError.warningTooHigh
        }
    }
    
    private func validateCriticalThreshold(_ value: Double) throws {
        if value < 5 {
            throw ValidationError.criticalTooLow
        }
        if value > 95 {
            throw ValidationError.criticalTooHigh
        }
    }
    
    private func validateWarningGreaterThanCritical(_ warning: Double, _ critical: Double) throws {
        if warning <= critical {
            throw ValidationError.warningMustExceedCritical
        }
    }
}
