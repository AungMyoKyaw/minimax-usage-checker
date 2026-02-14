import SwiftUI

struct StatsOverview: View {
    let totalUsed: Int
    let totalRemaining: Int
    let avgUsage: Double
    let modelCount: Int

    var overallStatus: UsageStatus {
        UsageStatus(percentage: avgUsage)
    }

    var body: some View {
        let columns = [
            GridItem(.flexible(), spacing: DesignTokens.Spacing.md),
            GridItem(.flexible(), spacing: DesignTokens.Spacing.md)
        ]

        LazyVGrid(columns: columns, spacing: DesignTokens.Spacing.md) {
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
                status: UsageStatus(percentage: 100 - (overallStatus == .critical ? 95 : (overallStatus == .warning ? 80 : 50)))
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
