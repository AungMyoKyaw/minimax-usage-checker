import SwiftUI

struct StatsOverview: View {
    let totalUsed: Int
    let totalRemaining: Int
    let avgUsage: Double
    let modelCount: Int

    var overallStatus: UsageStatus {
        UsageStatus(percentage: avgUsage)
    }

    var remainingStatus: UsageStatus {
        let remainingPercentage = totalRemaining > 0 
            ? (Double(totalRemaining) / Double(totalUsed + totalRemaining)) * 100 
            : 100
        return UsageStatus(percentage: remainingPercentage)
    }

    var body: some View {
        let columns = [
            GridItem(.flexible(), spacing: DesignTokens.Spacing.lg),
            GridItem(.flexible(), spacing: DesignTokens.Spacing.lg)
        ]

        LazyVGrid(columns: columns, spacing: DesignTokens.Spacing.lg) {
            StatCard(
                title: "Total Used",
                value: "\(totalUsed.formatted())",
                subtitle: "prompts",
                icon: "chart.bar.fill",
                status: overallStatus
            )

            StatCard(
                title: "Remaining",
                value: "\(totalRemaining.formatted())",
                subtitle: "prompts",
                icon: "hourglass",
                status: remainingStatus
            )

            StatCard(
                title: "Avg Usage",
                value: String(format: "%.1f%%", avgUsage),
                subtitle: "across models",
                icon: "percent",
                status: overallStatus
            )

            StatCard(
                title: "Models",
                value: "\(modelCount)",
                subtitle: "active",
                icon: "cpu",
                status: .safe
            )
        }
    }
}
