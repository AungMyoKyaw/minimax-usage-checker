import SwiftUI

enum EmptyStateType {
    case noAPIKey
    case noHistory
    case noModels
    case firstTimeUser

    var title: String {
        switch self {
        case .noAPIKey:
            return "Welcome to MiniMax Usage"
        case .noHistory:
            return "No history yet"
        case .noModels:
            return "No models available"
        case .firstTimeUser:
            return "Let's get started"
        }
    }

    var message: String {
        switch self {
        case .noAPIKey:
            return "Enter your API key to start tracking your usage"
        case .noHistory:
            return "Your usage history will appear here as data is collected"
        case .noModels:
            return "No model usage data is currently available"
        case .firstTimeUser:
            return "Track your AI usage in real-time with beautiful analytics"
        }
    }

    var icon: String {
        switch self {
        case .noAPIKey:
            return "brain.head.profile"
        case .noHistory:
            return "clock.arrow.circlepath"
        case .noModels:
            return "cpu"
        case .firstTimeUser:
            return "sparkles"
        }
    }
}
