import SwiftUI

struct ErrorStateView: View {
    let type: ErrorStateType
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.1))
                    .frame(width: 100, height: 100)

                Image(systemName: type.icon)
                    .font(.system(size: 40))
                    .foregroundStyle(.red)
            }

            VStack(spacing: DesignTokens.Spacing.sm) {
                Text(type.title)
                    .font(DesignTokens.Typography.headingMedium)
                    .fontWeight(.semibold)

                Text(type.message)
                    .font(DesignTokens.Typography.bodyMedium)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 320)
            }

            Button(action: onRetry) {
                Text(type.actionLabel)
                    .fontWeight(.semibold)
                    .frame(maxWidth: 200)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(DesignTokens.Spacing.xl)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(type.title): \(type.message)")
    }
}
