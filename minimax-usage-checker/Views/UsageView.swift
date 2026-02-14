import SwiftUI

struct UsageView: View {
    @ObservedObject var viewModel: UsageViewModel

    var sortedModels: [ModelRemain] {
        viewModel.modelRemains.sorted { $0.usagePercentage > $1.usagePercentage }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.md) {
                if viewModel.modelRemains.isEmpty {
                    EmptyStateView(type: .noModels)
                        .frame(height: 300)
                } else {
                    ForEach(sortedModels) { model in
                        ModelCard(model: model)
                            .listRowInsets(EdgeInsets(
                                top: DesignTokens.Spacing.sm,
                                leading: DesignTokens.Spacing.md,
                                bottom: DesignTokens.Spacing.sm,
                                trailing: DesignTokens.Spacing.md
                            ))
                    }
                }
            }
            .padding(DesignTokens.Spacing.lg)
        }
        .background(DesignTokens.Colors.surfaceTertiary.opacity(0.5))
    }
}
