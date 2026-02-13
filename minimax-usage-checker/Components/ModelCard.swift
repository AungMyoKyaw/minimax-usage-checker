import SwiftUI

struct ModelCard: View {
    let model: ModelRemain
    @State private var isExpanded: Bool = false

    var status: UsageStatus {
        UsageStatus(percentage: model.usagePercentage)
    }

    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                isExpanded.toggle()
            }) {
                HStack(spacing: DesignTokens.Spacing.md) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(model.modelName)
                            .font(DesignTokens.Typography.headingMedium)
                            .foregroundStyle(.primary)

                        Text(model.formattedWindowRange)
                            .font(DesignTokens.Typography.caption)
                            .foregroundStyle(.tertiary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text(model.formattedRemainingTime)
                            .font(DesignTokens.Typography.headingMedium)
                            .foregroundStyle(status.color)

                        Text("\(Int(model.usagePercentage))% used")
                            .font(DesignTokens.Typography.caption)
                            .foregroundStyle(.secondary)
                    }

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.appSubtle(reduceMotion: reduceMotion), value: isExpanded)
                }
                .padding(DesignTokens.Spacing.md)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                    Divider()

                    LinearProgressView(
                        progress: model.usagePercentage / 100,
                        status: status,
                        height: 12
                    )

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Used")
                                .font(DesignTokens.Typography.caption)
                                .foregroundStyle(.secondary)
                            Text("\(model.usedCount.formatted())")
                                .font(DesignTokens.Typography.headingMedium)
                                .foregroundStyle(.primary)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 2) {
                            Text("Remaining")
                                .font(DesignTokens.Typography.caption)
                                .foregroundStyle(.secondary)
                            Text("\(model.currentIntervalRemainingCount.formatted())")
                                .font(DesignTokens.Typography.headingMedium)
                                .foregroundStyle(status.color)
                        }
                    }

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Window Start")
                                .font(DesignTokens.Typography.caption)
                                .foregroundStyle(.secondary)
                            Text(model.startTimeFormatted.formatted(date: .abbreviated, time: .shortened))
                                .font(DesignTokens.Typography.bodyMedium)
                                .foregroundStyle(.primary)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 2) {
                            Text("Window End")
                                .font(DesignTokens.Typography.caption)
                                .foregroundStyle(.secondary)
                            Text(model.endTimeFormatted.formatted(date: .abbreviated, time: .shortened))
                                .font(DesignTokens.Typography.bodyMedium)
                                .foregroundStyle(.primary)
                        }
                    }
                }
                .padding(.horizontal, DesignTokens.Spacing.md)
                .padding(.bottom, DesignTokens.Spacing.md)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.xl)
                .fill(DesignTokens.Colors.surfacePrimary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.xl)
                .stroke(status.color.opacity(isExpanded ? 0.3 : 0.15), lineWidth: isExpanded ? 2 : 1)
        )
        .shadow(radius: isExpanded ? 12 : 8)
        .animation(.appSpring(reduceMotion: reduceMotion), value: isExpanded)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(model.modelName), \(Int(model.usagePercentage)) percent used, \(model.formattedRemainingTime) remaining")
        .accessibilityHint("Double tap for details")
    }
}
