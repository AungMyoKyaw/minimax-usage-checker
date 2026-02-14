import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UsageViewModel()
    @State private var enteredAPIKey: String = ""
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.hasAPIKey {
                    MainView(viewModel: viewModel)
                } else {
                    OnboardingView(
                        apiKey: $enteredAPIKey,
                        onSubmit: {
                            viewModel.saveAPIKey(enteredAPIKey)
                            viewModel.startAutoRefresh(interval: 30)
                            Task { await viewModel.fetchUsage() }
                        }
                    )
                    .transition(
                        reduceMotion
                            ? .opacity
                            : .scale(scale: 0.95).combined(with: .opacity)
                    )
                }
            }
            .frame(minWidth: 300, minHeight: 400)
            .navigationTitle("MiniMax Usage")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    if viewModel.hasAPIKey {
                        Button(action: {
                            viewModel.clearAPIKey()
                        }) {
                            Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    }
                }
            }
        }
        .onAppear {
            enteredAPIKey = viewModel.apiKey
            if viewModel.hasAPIKey {
                viewModel.startAutoRefresh(interval: 30)
            }
        }
        .animation(.appTransition(reduceMotion: reduceMotion), value: viewModel.hasAPIKey)
        .dynamicTypeSize(.medium ... .large)
    }
}

#Preview {
    ContentView()
}
