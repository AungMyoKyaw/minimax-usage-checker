//
//  UsageViewModel.swift
//  minimax-usage-checker
//
//  Created by Aung Myo Kyaw on 2/13/26.
//

import Foundation
import Combine

@MainActor
class UsageViewModel: ObservableObject {
    @Published var modelRemains: [ModelRemain] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var apiKey: String = ""

    private var timer: Timer?
    private let userDefaultsKey = "minimax_api_key"

    init() {
        loadAPIKey()
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func loadAPIKey() {
        apiKey = UserDefaults.standard.string(forKey: userDefaultsKey) ?? ""
    }

    func saveAPIKey(_ key: String) {
        apiKey = key
        UserDefaults.standard.set(key, forKey: userDefaultsKey)
    }

    func clearAPIKey() {
        apiKey = ""
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }

    var hasAPIKey: Bool {
        !apiKey.isEmpty
    }

    func fetchUsage() async {
        guard hasAPIKey else {
            errorMessage = "Please enter your API key"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await MiniMaxAPIService.shared.fetchUsage(apiKey: apiKey)

            if response.baseResp.isSuccess {
                modelRemains = response.modelRemains
                errorMessage = nil
            } else {
                errorMessage = response.baseResp.statusMsg
                modelRemains = []
            }
        } catch let error as APIError {
            errorMessage = error.errorDescription
            modelRemains = []
        } catch {
            errorMessage = error.localizedDescription
            modelRemains = []
        }

        isLoading = false
    }

    func startAutoRefresh(interval: TimeInterval = 30) {
        stopTimer()
        Task {
            await fetchUsage()
        }
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                await self?.fetchUsage()
            }
        }
    }

    func stopAutoRefresh() {
        stopTimer()
    }
}
