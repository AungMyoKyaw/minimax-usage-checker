import SwiftUI

enum TabIdentifier: String, CaseIterable {
    case dashboard
    case usage
    case history

    var label: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .usage: return "Usage"
        case .history: return "History"
        }
    }

    var icon: String {
        switch self {
        case .dashboard: return "chart.bar.fill"
        case .usage: return "cpu"
        case .history: return "clock.arrow.circlepath"
        }
    }
}

struct TabBar: View {
    @Binding var selectedTab: TabIdentifier
    let isLoading: Bool
    let onRefresh: () -> Void

    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabIdentifier.allCases, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                }) {
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 14))
                        Text(tab.label)
                            .font(DesignTokens.Typography.bodyMedium)
                            .fontWeight(selectedTab == tab ? .semibold : .regular)
                    }
                    .foregroundStyle(selectedTab == tab ? .white : .secondary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                            .fill(selectedTab == tab ? Color.accentColor : Color.clear)
                    )
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("\(tab.label) tab")
                .accessibilityValue(selectedTab == tab ? "Selected" : "Not selected")
                .accessibilityHint("Selects \(tab.label) view")
            }

            Spacer()

            Button(action: onRefresh) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.7)
                        .frame(width: 20, height: 20)
                } else {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 14))
                }
            }
            .buttonStyle(.plain)
            .padding(10)
            .disabled(isLoading)
            .accessibilityLabel("Refresh data")
        }
        .padding(.horizontal, DesignTokens.Spacing.md)
        .padding(.vertical, DesignTokens.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .fill(DesignTokens.Colors.surfaceSecondary)
        )
        .animation(.appSubtle(reduceMotion: reduceMotion), value: selectedTab)
    }
}
