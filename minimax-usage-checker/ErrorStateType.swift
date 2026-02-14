import SwiftUI

enum ErrorStateType {
    case networkError
    case invalidAPIKey
    case rateLimited
    case serviceUnavailable
    case unknown(String)

    var title: String {
        switch self {
        case .networkError:
            return "Connection Issue"
        case .invalidAPIKey:
            return "Invalid API Key"
        case .rateLimited:
            return "Rate Limited"
        case .serviceUnavailable:
            return "Service Unavailable"
        case .unknown:
            return "Something went wrong"
        }
    }

    var message: String {
        switch self {
        case .networkError:
            return "Please check your internet connection and try again"
        case .invalidAPIKey:
            return "Your API key may have changed. Please update it."
        case .rateLimited:
            return "You've made too many requests. Please wait a moment."
        case .serviceUnavailable:
            return "MiniMax services are temporarily unavailable."
        case .unknown(let detail):
            return detail
        }
    }

    var actionLabel: String {
        switch self {
        case .networkError, .serviceUnavailable, .unknown:
            return "Try Again"
        case .invalidAPIKey:
            return "Update API Key"
        case .rateLimited:
            return "Wait & Retry"
        }
    }

    var icon: String {
        switch self {
        case .networkError:
            return "wifi.exclamationmark"
        case .invalidAPIKey:
            return "key.fill"
        case .rateLimited:
            return "hourglass"
        case .serviceUnavailable:
            return "server.rack"
        case .unknown:
            return "exclamationmark.triangle"
        }
    }
}
