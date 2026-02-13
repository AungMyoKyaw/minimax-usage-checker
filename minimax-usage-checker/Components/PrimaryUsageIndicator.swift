import SwiftUI

struct PrimaryUsageIndicator: View {
    let modelName: String
    let progress: Double
    let remainingTime: String
    let usedCount: Int
    let totalCount: Int

    var status: UsageStatus {
        UsageStatus(percentage: progress * 100)
    }

    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            CircularProgressView(
                progress: progress,
                status: status,
                size: CGSize(width: 160, height: 160),
                lineWidth: 12
            )

            VStack(spacing: DesignTokens.Spacing.sm) {
                Text(modelName)
                    .font(DesignTokens.Typography.headingMedium)
                    .foregroundStyle(.primary)

                Text("\(remainingTime) remaining")
                    .font(DesignTokens.Typography.bodyMedium)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: DesignTokens.Spacing.md) {
                VStack(spacing: 2) {
                    Text("\(usedCount.formatted())")
                        .font(DesignTokens.Typography.headingMedium)
                        .foregroundStyle(status.color)
                    Text("Used")
                        .font(DesignTokens.Typography.caption)
                        .foregroundStyle(.secondary)
                }

                Text("/")
                    .foregroundStyle(.tertiary)

                VStack(spacing: 2) {
                    Text("\(totalCount.formatted())")
                        .font(DesignTokens.Typography.headingMedium)
                        .foregroundStyle(.primary)
                    Text("Total")
                        .font(DesignTokens.Typography.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(DesignTokens.Spacing.xl)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.xl)
                .fill(DesignTokens.Colors.surfacePrimary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.xl)
                .stroke(status.color.opacity(0.2), lineWidth: 2)
        )
        .shadow(color: status.color.opacity(0.1), radius: 16, y: 8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(modelName) usage: \(Int(progress * 100)) percent used, \(remainingTime) remaining, \(usedCount) of \(totalCount) prompts")
    }
}
