import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    // Track which alerts have been sent to avoid spam
    private var alertsSent: Set<String> = []
    
    private init() {}
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error.localizedDescription)")
            }
        }
    }
    
    func checkAndNotify(modelRemains: [ModelRemain]) {
        let settings = AlertSettingsManager.shared.settings
        
        for model in modelRemains {
            checkModelUsage(model, settings: settings)
        }
    }
    
    private func checkModelUsage(_ model: ModelRemain, settings: AlertSettings) {
        // Check if snoozed
        if settings.isSnoozedCurrently {
            return
        }
        
        // Check if model is enabled
        if !AlertSettingsManager.shared.isModelEnabled(model.modelName) {
            return
        }
        
        let percentage = model.usagePercentage
        let modelKey = "\(model.modelName)_\(model.windowTimeRange)"
        
        // Check if we've already sent an alert for this model in this window
        if alertsSent.contains(modelKey) {
            return
        }
        
        // Get thresholds for this model
        let thresholds = AlertSettingsManager.shared.getThreshold(for: model.modelName)
        
        if percentage >= thresholds.critical {
            // Critical alert
            sendCriticalNotification(for: model, settings: settings)
            alertsSent.insert(modelKey)
            recordAlert(model: model, alertType: .critical)
        } else if percentage >= thresholds.warning {
            // Warning alert
            sendWarningNotification(for: model, settings: settings)
            alertsSent.insert(modelKey)
            recordAlert(model: model, alertType: .warning)
        }
    }
    
    private func sendWarningNotification(for model: ModelRemain, settings: AlertSettings) {
        let content = UNMutableNotificationContent()
        content.title = "⚠️ MiniMax Usage Warning"
        
        let message = settings.effectiveWarningMessage
            .replacingOccurrences(of: "{model}", with: model.modelName)
            .replacingOccurrences(of: "{remaining}", with: model.remainsTimeFormatted)
            .replacingOccurrences(of: "{percent}", with: String(format: "%.0f", 100 - model.usagePercentage))
        content.body = message
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "warning_\(model.modelName)_\(model.windowTimeRange)",
            content: content,
            trigger: nil
        )
        
        notificationCenter.add(request)
    }
    
    private func sendCriticalNotification(for model: ModelRemain, settings: AlertSettings) {
        let content = UNMutableNotificationContent()
        content.title = "🚨 MiniMax Credits Low!"
        
        let message = settings.effectiveCriticalMessage
            .replacingOccurrences(of: "{model}", with: model.modelName)
            .replacingOccurrences(of: "{remaining}", with: model.remainsTimeFormatted)
            .replacingOccurrences(of: "{percent}", with: String(format: "%.0f", 100 - model.usagePercentage))
        content.body = message
        content.sound = .defaultCritical
        
        let request = UNNotificationRequest(
            identifier: "critical_\(model.modelName)_\(model.windowTimeRange)",
            content: content,
            trigger: nil
        )
        
        notificationCenter.add(request)
    }
    
    private func recordAlert(model: ModelRemain, alertType: AlertType) {
        Task { @MainActor in
            AlertHistoryManager.shared.addEntry(
                modelName: model.modelName,
                usagePercentage: model.usagePercentage,
                alertType: alertType
            )
        }
    }
    
    func clearAlerts() {
        alertsSent.removeAll()
    }
}
