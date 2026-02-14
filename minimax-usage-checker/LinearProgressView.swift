import SwiftUI

struct LinearProgressView: View {
    let progress: Double
    let status: UsageStatus
    var height: CGFloat = 6

    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(Color.gray.opacity(0.1))

                RoundedRectangle(cornerRadius: height / 2)
                    .fill(
                        LinearGradient(
                            colors: [status.color, status.color.opacity(0.6)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * progress)
                    .animation(.appSpring(reduceMotion: reduceMotion), value: progress)
            }
        }
        .frame(height: height)
    }
}
