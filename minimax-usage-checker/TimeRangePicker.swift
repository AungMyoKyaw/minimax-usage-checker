import SwiftUI

struct TimeRangePicker: View {
    @Binding var selectedRange: TimeRange

    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Button(action: {
                    selectedRange = range
                }) {
                    Text(range.rawValue)
                        .font(DesignTokens.Typography.bodyMedium)
                        .fontWeight(selectedRange == range ? .semibold : .regular)
                        .foregroundStyle(selectedRange == range ? .white : .secondary)
                        .frame(minWidth: 60)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                                .fill(selectedRange == range ? Color.accentColor : Color.clear)
                        )
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(DesignTokens.Spacing.xs)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .fill(DesignTokens.Colors.surfaceSecondary)
        )
        .animation(.appSpring(reduceMotion: reduceMotion), value: selectedRange)
    }
}
