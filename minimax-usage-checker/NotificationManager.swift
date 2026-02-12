import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    // Notification thresholds (percentage)
    private let warningThreshold: Double = 10.0
    private let criticalThreshold: Double = 5.0
    
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
        for model in modelRemains {
            checkModelUsage(model)
        }
    }
    
    private func checkModelUsage(_ model: ModelRemain) {
        let percentage = model.usagePercentage
        let modelKey = "\(model.modelName)_\(model.windowTimeRange)"
        
        // Check if we've already sent an alert for this model in this window
        if alertsSent.contains(modelKey) {
            return
        }
        
        if percentage >= (100 - warningThreshold) && percentage < (100 - criticalThreshold) {
            // Warning: between 85-95% used (15-5% remaining)
            sendWarningNotification(for: model)
            alertsSent.insert(modelKey)
        } else if percentage >= (100 - criticalThreshold) {
            // Critical: 95%+ used (5% or less remaining)
            sendCriticalNotification(for: model)
            alertsSent.insert(modelKey)
        }
    }
    
    private func sendWarningNotification(for model: ModelRemain) {
        let content = UNMutableNotificationContent()
        content.title = "⚠️ MiniMax Usage Warning"
        content.body = "\(model.modelName): Only \(model.remainsTimeFormatted) remaining (\(String(format: "%.0f", 100 - model.usagePercentage))% left)"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "warning_\(model.modelName)",
            content: content,
            trigger: nil
        )
        
        notificationCenter.add(request)
    }
    
    private func sendCriticalNotification(for model: ModelRemain) {
        let content = UNMutableNotificationContent()
        content.title = "🚨 MiniMax Credits Low!"
        content.body = "\(model.modelName): Only \(model.remainsTimeFormatted) remaining! Time to top up."
        content.sound = .defaultCritical
        
        let request = UNNotificationRequest(
            identifier: "critical_\(model.modelName)",
            content: content,
            trigger: nil
        )
        
        notificationCenter.add(request)
    }
    
    func clearAlerts() {
        alertsSent.removeAll()
    }
}
