import Foundation
import Combine

@MainActor
class AlertHistoryManager: ObservableObject {
    static let shared = AlertHistoryManager()
    
    private let userDefaults = UserDefaults.standard
    private let historyKey = "alert_history"
    private let maxHistoryCount = 100
    
    @Published var history: [AlertHistoryEntry] {
        didSet {
            saveHistory()
        }
    }
    
    var isAtCapacity: Bool {
        history.count >= maxHistoryCount
    }
    
    private init() {
        if let data = userDefaults.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([AlertHistoryEntry].self, from: data) {
            self.history = decoded
        } else {
            self.history = []
        }
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(history) {
            userDefaults.set(encoded, forKey: historyKey)
        }
    }
    
    func addEntry(_ entry: AlertHistoryEntry) {
        history.insert(entry, at: 0)
        
        if history.count > maxHistoryCount {
            history = Array(history.prefix(maxHistoryCount))
        }
    }
    
    func addEntry(modelName: String, usagePercentage: Double, alertType: AlertType) {
        let entry = AlertHistoryEntry(
            modelName: modelName,
            usagePercentage: usagePercentage,
            alertType: alertType
        )
        addEntry(entry)
    }
    
    func clearHistory() {
        history.removeAll()
    }
}
