import Foundation

struct ModelAlertSettings: Codable, Equatable {
    var warningThreshold: Double
    var criticalThreshold: Double
    var isEnabled: Bool
    
    static let defaultSettings = ModelAlertSettings(
        warningThreshold: 85.0,
        criticalThreshold: 95.0,
        isEnabled: true
    )
    
    enum CodingKeys: String, CodingKey {
        case warningThreshold = "warning_threshold"
        case criticalThreshold = "critical_threshold"
        case isEnabled = "is_enabled"
    }
}
