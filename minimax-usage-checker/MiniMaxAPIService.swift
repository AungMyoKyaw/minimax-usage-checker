//
//  MiniMaxAPIService.swift
//  minimax-usage-checker
//
//  Created by Aung Myo Kyaw on 2/13/26.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case noAPIKey
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noAPIKey:
            return "No API key configured"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

class MiniMaxAPIService {
    static let shared = MiniMaxAPIService()

    private let apiEndpoint = "https://api.minimax.io/v1/api/openplatform/coding_plan/remains"

    private init() {}

    func fetchUsage(apiKey: String) async throws -> CodingPlanResponse {
        guard !apiKey.isEmpty else {
            throw APIError.noAPIKey
        }

        guard let url = URL(string: apiEndpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.httpError(httpResponse.statusCode)
            }

            do {
                let decoder = JSONDecoder()
                let codingPlanResponse = try decoder.decode(CodingPlanResponse.self, from: data)
                return codingPlanResponse
            } catch {
                throw APIError.decodingError(error)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}
