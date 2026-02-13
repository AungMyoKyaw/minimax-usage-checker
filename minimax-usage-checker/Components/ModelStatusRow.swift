import SwiftUI

struct ModelStatusRow: View {
    let modelName: String
    let progress: Double
    let remainingTime: String
    let windowRange: String

    var status: UsageStatus {
        UsageStatus(percentage: progress * 100)
    }

    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            Circle()
                .fill(status.color)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 2) {
                Text(modelName)
                    .font(DesignTokens.Typography.bodyMedium)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)

                Text(windowRange)
                    .font(DesignTokens.Typography.captionSmall)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(remainingTime)
                    .font(DesignTokens.Typography.bodyMedium)
                    .fontWeight(.medium)
                    .foregroundStyle(status.color)

                Text("\(Int(progress * 100))% used")
                    .font(DesignTokens.Typography.captionSmall)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, DesignTokens.Spacing.sm)
        .padding(.horizontal, DesignTokens.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .fill(DesignTokens.Colors.surfacePrimary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .stroke(status.color.opacity(0.1), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(modelName): \(Int(progress * 100)) percent used, \(remainingTime) remaining, window \(windowRange)")
    }
}
