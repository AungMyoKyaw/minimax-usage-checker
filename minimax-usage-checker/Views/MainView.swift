import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: UsageViewModel
    @State private var selectedTab: TabIdentifier = .dashboard

    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        VStack(spacing: 0) {
            TabBar(
                selectedTab: $selectedTab,
                isLoading: viewModel.isLoading,
                onRefresh: { Task { await viewModel.fetchUsage() } }
            )
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.top, DesignTokens.Spacing.md)

            Group {
                switch selectedTab {
                case .dashboard:
                    DashboardView(viewModel: viewModel)
                case .usage:
                    UsageView(viewModel: viewModel)
                case .history:
                    HistoryView(viewModel: viewModel)
                }
            }
            .transition(
                reduceMotion
                    ? .opacity
                    : .asymmetric(
                        insertion: .scale(scale: 0.98).combined(with: .opacity),
                        removal: .opacity
                    )
            )
        }
        .animation(.appTransition(reduceMotion: reduceMotion), value: selectedTab)
    }
}
