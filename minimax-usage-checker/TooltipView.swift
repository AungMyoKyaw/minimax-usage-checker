import SwiftUI

struct TooltipView: View {
    let title: String
    let value: String
    var detail: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(DesignTokens.Typography.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(DesignTokens.Typography.headingMedium)
                .foregroundStyle(.primary)

            if let detail = detail {
                Text(detail)
                    .font(DesignTokens.Typography.captionSmall)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(DesignTokens.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .fill(DesignTokens.Colors.surfacePrimary)
                .shadow(radius: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .stroke(DesignTokens.Colors.borderEmphasis, lineWidth: 1)
        )
    }
}
