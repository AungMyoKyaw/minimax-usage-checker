import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: UsageViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                TimeRangePicker(selectedRange: $viewModel.selectedTimeRange)

                TimelineChart(data: viewModel.dailyUsageData)

                if viewModel.filteredSnapshots.isEmpty {
                    EmptyStateView(type: .noHistory)
                        .frame(height: 200)
                } else {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                        Text("History")
                            .font(DesignTokens.Typography.headingMedium)
                            .foregroundStyle(.primary)

                        ForEach(viewModel.filteredSnapshots.suffix(20).reversed()) { snapshot in
                            HistoryRow(snapshot: snapshot)
                        }
                    }
                    .padding(DesignTokens.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                            .fill(DesignTokens.Colors.surfacePrimary)
                    )
                }
            }
            .padding(DesignTokens.Spacing.lg)
        }
        .background(DesignTokens.Colors.surfaceTertiary.opacity(0.5))
    }
}

struct HistoryRow: View {
    let snapshot: SnapshotData

    var status: UsageStatus {
        UsageStatus(percentage: snapshot.usagePercentage)
    }

    var body: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            Circle()
                .fill(status.color)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 2) {
                Text(snapshot.modelName)
                    .font(DesignTokens.Typography.bodyMedium)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)

                Text(snapshot.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(DesignTokens.Typography.captionSmall)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(snapshot.usedCount.formatted()) used")
                    .font(DesignTokens.Typography.bodyMedium)
                    .fontWeight(.medium)
                    .foregroundStyle(status.color)

                Text("\(snapshot.remainsTimeFormatted) left")
                    .font(DesignTokens.Typography.captionSmall)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, DesignTokens.Spacing.xs)
    }
}
