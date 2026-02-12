//
//  CodingPlanModels.swift
//  minimax-usage-checker
//
//  Created by Aung Myo Kyaw on 2/13/26.
//

import Foundation

// MARK: - API Response Models

struct CodingPlanResponse: Codable {
    let modelRemains: [ModelRemain]
    let baseResp: BaseResp

    enum CodingKeys: String, CodingKey {
        case modelRemains = "model_remains"
        case baseResp = "base_resp"
    }
}

struct ModelRemain: Codable, Identifiable {
    let startTime: Int64
    let endTime: Int64
    let remainsTime: Int64
    let currentIntervalTotalCount: Int
    let currentIntervalRemainingCount: Int
    let modelName: String

    enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case endTime = "end_time"
        case remainsTime = "remains_time"
        case currentIntervalTotalCount = "current_interval_total_count"
        case currentIntervalRemainingCount = "current_interval_usage_count"
        case modelName = "model_name"
    }

    var id: String { modelName }

    // Computed properties for display
    var usedPrompts: Int {
        currentIntervalTotalCount - currentIntervalRemainingCount
    }
    
    var remainingPrompts: Int {
        currentIntervalRemainingCount
    }

    var usagePercentage: Double {
        guard currentIntervalTotalCount > 0 else { return 0 }
        let usedCount = currentIntervalTotalCount - currentIntervalRemainingCount
        return Double(usedCount) / Double(currentIntervalTotalCount) * 100
    }

    var remainsTimeFormatted: String {
        let totalSeconds = remainsTime / 1000
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }

    var startTimeFormatted: Date {
        Date(timeIntervalSince1970: Double(startTime) / 1000.0)
    }

    var endTimeFormatted: Date {
        Date(timeIntervalSince1970: Double(endTime) / 1000.0)
    }

    var windowTimeRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return "\(formatter.string(from: startTimeFormatted)) - \(formatter.string(from: endTimeFormatted))"
    }
}

struct BaseResp: Codable {
    let statusCode: Int
    let statusMsg: String

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMsg = "status_msg"
    }

    var isSuccess: Bool {
        statusCode == 0
    }
}
