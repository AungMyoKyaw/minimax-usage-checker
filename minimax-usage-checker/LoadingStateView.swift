import SwiftUI

struct LoadingStateView: View {
    var message: String? = nil

    @State private var shimmerOffset: CGFloat = -200

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            VStack(spacing: DesignTokens.Spacing.md) {
                RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                    .fill(DesignTokens.Colors.surfaceSecondary)
                    .frame(height: 24)
                    .overlay(
                        GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.clear,
                                            DesignTokens.Colors.surfacePrimary.opacity(0.5),
                                            Color.clear
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 100)
                                .offset(x: shimmerOffset)
                                .mask(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm).frame(height: 24))
                        }
                    )
                    .clipped()

                HStack(spacing: DesignTokens.Spacing.md) {
                    ForEach(0..<2, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                            .fill(DesignTokens.Colors.surfaceSecondary)
                            .frame(height: 80)
                    }
                }
            }

            if let message = message {
                Text(message)
                    .font(DesignTokens.Typography.bodyMedium)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(DesignTokens.Spacing.lg)
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                shimmerOffset = 200
            }
        }
    }
}
