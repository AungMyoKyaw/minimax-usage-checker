import SwiftUI

enum UsageStatus {
    case safe
    case warning
    case critical

    init(percentage: Double) {
        if percentage > 90 {
            self = .critical
        } else if percentage > 70 {
            self = .warning
        } else {
            self = .safe
        }
    }

    var color: Color {
        switch self {
        case .safe:
            return DesignTokens.Colors.usageSafe
        case .warning:
            return DesignTokens.Colors.usageWarning
        case .critical:
            return DesignTokens.Colors.usageCritical
        }
    }
}
