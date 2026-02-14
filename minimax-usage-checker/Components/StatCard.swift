import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let status: UsageStatus

    @State private var isHovered = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(status.color)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(DesignTokens.Typography.headingLarge)
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(.secondary)
            }

            Text(title)
                .font(DesignTokens.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                .fill(DesignTokens.Colors.surfacePrimary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                .stroke(status.color.opacity(0.2), lineWidth: 1)
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .shadow(
            color: Color.black.opacity(isHovered ? 0.12 : 0.06),
            radius: isHovered ? 12 : 6,
            y: isHovered ? 4 : 2
        )
        .animation(.appSubtle(reduceMotion: reduceMotion), value: isHovered)
        .onHover { isHovered = $0 }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value) \(subtitle)")
    }
}
