import Foundation

enum AlertType: String, Codable, CaseIterable {
    case warning
    case critical
    
    var displayName: String {
        switch self {
        case .warning:
            return "Warning"
        case .critical:
            return "Critical"
        }
    }
    
    var iconName: String {
        switch self {
        case .warning:
            return "exclamationmark.triangle.fill"
        case .critical:
            return "xmark.octagon.fill"
        }
    }
}

enum SnoozeDuration: CaseIterable, Identifiable {
    case fifteenMinutes
    case oneHour
    case fourHours
    case twentyFourHours
    
    var id: SnoozeDuration { self }
    
    var seconds: TimeInterval {
        switch self {
        case .fifteenMinutes:
            return 15 * 60
        case .oneHour:
            return 60 * 60
        case .fourHours:
            return 4 * 60 * 60
        case .twentyFourHours:
            return 24 * 60 * 60
        }
    }
    
    var displayName: String {
        switch self {
        case .fifteenMinutes:
            return "15 minutes"
        case .oneHour:
            return "1 hour"
        case .fourHours:
            return "4 hours"
        case .twentyFourHours:
            return "24 hours"
        }
    }
}

enum ValidationError: LocalizedError {
    case warningTooLow
    case warningTooHigh
    case criticalTooLow
    case criticalTooHigh
    case warningMustExceedCritical
    case modelNotFound
    
    var errorDescription: String? {
        switch self {
        case .warningTooLow:
            return "Warning threshold must be at least 10%"
        case .warningTooHigh:
            return "Warning threshold must be at most 99%"
        case .criticalTooLow:
            return "Critical threshold must be at least 5%"
        case .criticalTooHigh:
            return "Critical threshold must be at most 95%"
        case .warningMustExceedCritical:
            return "Warning threshold must be greater than critical threshold"
        case .modelNotFound:
            return "Model not found"
        }
    }
}
