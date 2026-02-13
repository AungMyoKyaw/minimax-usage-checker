import SwiftUI
import Charts

struct TimelineChart: View {
    let data: [DailyUsage]

    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("Usage Over Time")
                .font(DesignTokens.Typography.headingMedium)
                .foregroundStyle(.primary)

            if data.isEmpty {
                EmptyStateView(type: .noHistory)
                    .frame(height: 200)
            } else {
                Chart(data) { item in
                    BarMark(
                        x: .value("Date", item.date, unit: .day),
                        y: .value("Used", item.usedCount)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.accentColor, Color.accentColor.opacity(0.6)],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .cornerRadius(4)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: max(1, data.count / 7))) { value in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                        AxisValueLabel()
                    }
                }
                .frame(height: 200)
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                .fill(DesignTokens.Colors.surfacePrimary)
        )
    }
}
