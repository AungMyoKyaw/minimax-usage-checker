import Foundation
import Combine
import UserNotifications

struct SnapshotData: Codable, Identifiable {
    let id = UUID()
    let timestamp: Date
    let modelName: String
    let windowStartTime: Int64
    let windowEndTime: Int64
    let remainsTime: Int64
    let totalCount: Int
    let remainingCount: Int
    
    var usedCount: Int {
        totalCount - remainingCount
    }
    
    var usagePercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(usedCount) / Double(totalCount) * 100
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
    
    init(from model: ModelRemain) {
        self.timestamp = Date()
        self.modelName = model.modelName
        self.windowStartTime = model.startTime
        self.windowEndTime = model.endTime
        self.remainsTime = model.remainsTime
        self.totalCount = model.currentIntervalTotalCount
        self.remainingCount = model.currentIntervalRemainingCount
    }
}

enum TimeRange: String, CaseIterable {
    case today = "Today"
    case week = "Week"
    case month = "Month"
    case all = "All"
}

@MainActor
class UsageViewModel: ObservableObject {
    @Published var modelRemains: [ModelRemain] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingInitially: Bool = true
    @Published var errorMessage: String?
    @Published var apiKey: String = ""
    @Published var selectedTimeRange: TimeRange = .week
    
    @Published var snapshots: [SnapshotData] = []
    
    private var timer: Timer?
    private let userDefaultsKey = "minimax_api_key"
    private let snapshotsKey = "minimax_usage_snapshots"

    init() {
        loadAPIKey()
        requestNotificationPermission()
        loadSnapshots()
    }
    
    private func requestNotificationPermission() {
        NotificationManager.shared.requestAuthorization()
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
    
    private func loadSnapshots() {
        guard let data = UserDefaults.standard.data(forKey: snapshotsKey) else {
            snapshots = []
            return
        }
        
        do {
            snapshots = try JSONDecoder().decode([SnapshotData].self, from: data)
        } catch {
            print("Failed to load snapshots: \(error)")
            snapshots = []
        }
    }
    
    private func saveSnapshotsToDisk() {
        do {
            let data = try JSONEncoder().encode(snapshots)
            UserDefaults.standard.set(data, forKey: snapshotsKey)
        } catch {
            print("Failed to save snapshots: \(error)")
        }
    }
    
    func saveSnapshot() {
        for model in modelRemains {
            let snapshot = SnapshotData(from: model)
            snapshots.append(snapshot)
        }
        
        if snapshots.count > 10000 {
            snapshots = Array(snapshots.suffix(10000))
        }
        
        saveSnapshotsToDisk()
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
                saveSnapshot()
                NotificationManager.shared.checkAndNotify(modelRemains: modelRemains)
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
        isLoadingInitially = false
        loadFilteredSnapshots()
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
    
    func loadFilteredSnapshots() {
        objectWillChange.send()
    }
    
    var filteredSnapshots: [SnapshotData] {
        let startDate: Date
        switch selectedTimeRange {
        case .today:
            startDate = Calendar.current.startOfDay(for: Date())
        case .week:
            startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        case .month:
            startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        case .all:
            startDate = Date.distantPast
        }
        
        return snapshots.filter { $0.timestamp >= startDate }
    }
    
    var totalUsedPrompts: Int {
        filteredSnapshots.reduce(0) { $0 + $1.usedCount }
    }
    
    var totalRemainingPrompts: Int {
        filteredSnapshots.reduce(0) { $0 + $1.remainingCount }
    }
    
    var averageUsagePercentage: Double {
        guard !filteredSnapshots.isEmpty else { return 0 }
        let total = filteredSnapshots.reduce(0.0) { $0 + $1.usagePercentage }
        return total / Double(filteredSnapshots.count)
    }
    
    var dailyUsageData: [DailyUsage] {
        let calendar = Calendar.current
        var dailyMap: [Date: DailyUsage] = [:]
        
        for snapshot in filteredSnapshots {
            let day = calendar.startOfDay(for: snapshot.timestamp)
            if var existing = dailyMap[day] {
                existing.usedCount += snapshot.usedCount
                existing.remainingCount += snapshot.remainingCount
                dailyMap[day] = existing
            } else {
                dailyMap[day] = DailyUsage(
                    date: day,
                    usedCount: snapshot.usedCount,
                    remainingCount: snapshot.remainingCount
                )
            }
        }
        
        return dailyMap.values.sorted { $0.date < $1.date }
    }
}

struct DailyUsage: Identifiable {
    let id = UUID()
    let date: Date
    var usedCount: Int
    var remainingCount: Int
    
    var totalCount: Int {
        usedCount + remainingCount
    }
    
    var usagePercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(usedCount) / Double(totalCount) * 100
    }
}
