import SwiftUI

struct ModelStatusList: View {
    let models: [ModelRemain]

    var sortedModels: [ModelRemain] {
        models.sorted { $0.usagePercentage > $1.usagePercentage }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Model Status")
                .font(DesignTokens.Typography.headingMedium)
                .foregroundStyle(.primary)

            if models.isEmpty {
                EmptyStateView(type: .noModels)
                    .frame(height: 150)
            } else {
                ForEach(sortedModels) { model in
                    ModelStatusRow(
                        modelName: model.modelName,
                        progress: model.usagePercentage / 100,
                        remainingTime: model.formattedRemainingTime,
                        windowRange: model.formattedWindowRange
                    )
                }
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                .fill(DesignTokens.Colors.surfacePrimary)
        )
    }
}
