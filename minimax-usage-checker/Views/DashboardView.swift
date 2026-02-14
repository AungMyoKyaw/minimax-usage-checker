import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: UsageViewModel

    var mostUrgentModel: ModelRemain? {
        viewModel.modelRemains.max(by: { $0.usagePercentage < $1.usagePercentage })
    }

    var totalUsed: Int {
        viewModel.modelRemains.reduce(0) { $0 + $1.usedCount }
    }

    var totalRemaining: Int {
        viewModel.modelRemains.reduce(0) { $0 + $1.currentIntervalRemainingCount }
    }

    var avgUsage: Double {
        guard !viewModel.modelRemains.isEmpty else { return 0 }
        return viewModel.modelRemains.map(\.usagePercentage).reduce(0, +) / Double(viewModel.modelRemains.count)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                if viewModel.isLoadingInitially {
                    LoadingStateView(message: "Loading usage data...")
                } else if let error = viewModel.errorMessage {
                    ErrorStateView(
                        type: .unknown(error),
                        onRetry: { Task { await viewModel.fetchUsage() } }
                    )
                } else if let mostUrgent = mostUrgentModel {
                    PrimaryUsageIndicator(
                        modelName: mostUrgent.modelName,
                        progress: mostUrgent.usagePercentage / 100,
                        remainingTime: mostUrgent.formattedRemainingTime,
                        usedCount: mostUrgent.usedCount,
                        totalCount: mostUrgent.currentIntervalTotalCount
                    )

                    StatsOverview(
                        totalUsed: totalUsed,
                        totalRemaining: totalRemaining,
                        avgUsage: avgUsage,
                        modelCount: viewModel.modelRemains.count
                    )

                    ModelStatusList(models: viewModel.modelRemains)
                } else {
                    EmptyStateView(type: .noModels)
                }
            }
            .padding(DesignTokens.Spacing.md)
        }
        .background(DesignTokens.Colors.surfaceTertiary.opacity(0.5))
    }
}
