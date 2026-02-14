import Foundation

struct AlertHistoryEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let modelName: String
    let usagePercentage: Double
    let alertType: AlertType
    let timestamp: Date
    
    init(modelName: String, usagePercentage: Double, alertType: AlertType) {
        self.id = UUID()
        self.modelName = modelName
        self.usagePercentage = usagePercentage
        self.alertType = alertType
        self.timestamp = Date()
    }
    
    init(id: UUID, modelName: String, usagePercentage: Double, alertType: AlertType, timestamp: Date) {
        self.id = id
        self.modelName = modelName
        self.usagePercentage = usagePercentage
        self.alertType = alertType
        self.timestamp = timestamp
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case modelName = "model_name"
        case usagePercentage = "usage_percentage"
        case alertType = "alert_type"
        case timestamp
    }
}
