import SwiftUI

struct OnboardingView: View {
    @Binding var apiKey: String
    let onSubmit: () -> Void

    @FocusState private var isInputFocused: Bool
    @FocusState private var isSubmitFocused: Bool
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    private var isValidAPIKey: Bool {
        !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.xxl) {
            Spacer()

            VStack(spacing: DesignTokens.Spacing.lg) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [DesignTokens.Colors.accentPrimary.opacity(0.4), DesignTokens.Colors.accentPrimary.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)

                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 48))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [DesignTokens.Colors.accentPrimary, DesignTokens.Colors.accentPrimary.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: DesignTokens.Colors.accentPrimary.opacity(0.3), radius: 20)

                VStack(spacing: DesignTokens.Spacing.sm) {
                    Text("MiniMax Usage")
                        .font(DesignTokens.Typography.displayMedium)

                    Text("Track your AI usage in real-time")
                        .font(DesignTokens.Typography.bodyMedium)
                        .foregroundStyle(DesignTokens.Colors.textSecondary)
                }
            }

            VStack(spacing: DesignTokens.Spacing.lg) {
                SecureField("API Key", text: $apiKey)
                    .textFieldStyle(.plain)
                    .padding(DesignTokens.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                            .fill(DesignTokens.Colors.surfaceSecondary)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                            .stroke(DesignTokens.Colors.borderSubtle, lineWidth: 1)
                    )
                    .frame(maxWidth: 400)
                    .focused($isInputFocused)
                    .submitLabel(.next)
                    .onSubmit {
                        if isValidAPIKey {
                            onSubmit()
                        }
                    }

                Button(action: onSubmit) {
                    HStack {
                        Text("Get Started")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .frame(maxWidth: 400)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!isValidAPIKey)
                .opacity(isValidAPIKey ? 1.0 : 0.5)
                .shadow(color: DesignTokens.Colors.accentPrimary.opacity(isValidAPIKey ? 0.3 : 0), radius: 8, y: 4)
                .focused($isSubmitFocused)
                .keyboardShortcut(.defaultAction)
            }

            Text("Your API key is stored locally and never leaves your device")
                .font(DesignTokens.Typography.captionSmall)
                .foregroundStyle(DesignTokens.Colors.textTertiary)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DesignTokens.Colors.surfaceTertiary.opacity(0.5))
        .onAppear {
            isInputFocused = true
        }
    }
}
