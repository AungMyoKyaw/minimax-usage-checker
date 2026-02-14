import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let status: UsageStatus
    var size: CGSize = CGSize(width: 80, height: 80)
    var lineWidth: CGFloat = 6
    var showPercentage: Bool = true

    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        ZStack {
            Circle()
                .stroke(status.color.opacity(0.15), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    status.color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.appValue(reduceMotion: reduceMotion), value: progress)

            if showPercentage {
                VStack(spacing: 2) {
                    Text("\(Int(progress * 100))")
                        .font(DesignTokens.Typography.displayMedium)
                    Text("% used")
                        .font(DesignTokens.Typography.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(width: size.width, height: size.height)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Usage progress")
        .accessibilityValue("\(Int(progress * 100)) percent used")
    }
}
