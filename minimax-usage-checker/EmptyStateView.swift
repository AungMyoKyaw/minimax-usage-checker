import SwiftUI

struct EmptyStateView: View {
    let type: EmptyStateType
    var action: (() -> Void)?

    @State private var isPulsing = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.accentColor.opacity(0.2), Color.accentColor.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)

                Image(systemName: type.icon)
                    .font(.system(size: 32))
                    .foregroundStyle(.secondary)
            }
            .scaleEffect(isPulsing ? 1.05 : 1.0)
            .animation(
                reduceMotion ? .default : .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                value: isPulsing
            )

            VStack(spacing: DesignTokens.Spacing.sm) {
                Text(type.title)
                    .font(DesignTokens.Typography.headingMedium)
                    .fontWeight(.semibold)

                Text(type.message)
                    .font(DesignTokens.Typography.bodyMedium)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 280)
            }

            if let action = action {
                Button(action: action) {
                    Text("Get Started")
                        .fontWeight(.semibold)
                        .frame(maxWidth: 200)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            if !reduceMotion {
                isPulsing = true
            }
        }
    }
}
