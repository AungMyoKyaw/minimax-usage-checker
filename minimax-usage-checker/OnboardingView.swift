import SwiftUI

struct OnboardingView: View {
    @Binding var apiKey: String
    let onSubmit: () -> Void

    @FocusState private var isInputFocused: Bool
    @FocusState private var isSubmitFocused: Bool
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var isButtonHovered: Bool = false
    
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
                        .font(DesignTokens.Typography.displayLarge)
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

            VStack(spacing: DesignTokens.Spacing.md) {
                ZStack {
                    if apiKey.isEmpty {
                        Text("API Key")
                            .font(DesignTokens.Typography.bodyMedium)
                            .foregroundStyle(DesignTokens.Colors.textTertiary)
                            .frame(maxWidth: 400, alignment: .leading)
                            .padding(.horizontal, DesignTokens.Spacing.md + 4)
                            .allowsHitTesting(false)
                    }
                    
                    SecureField("API Key", text: $apiKey)
                        .textFieldStyle(.plain)
                        .padding(DesignTokens.Spacing.md)
                        .padding(.horizontal, 4)
                        .frame(maxWidth: 400)
                        .focused($isInputFocused)
                        .submitLabel(.next)
                        .onSubmit {
                            if isValidAPIKey {
                                onSubmit()
                            }
                        }
                }
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                        .fill(DesignTokens.Colors.surfaceSecondary)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                        .stroke(
                            isInputFocused ? DesignTokens.Colors.accentPrimary :
                            DesignTokens.Colors.borderSubtle,
                            lineWidth: isInputFocused ? 2 : 1
                        )
                )
                .shadow(
                    color: isInputFocused ? DesignTokens.Colors.accentPrimary.opacity(0.15) : .clear,
                    radius: isInputFocused ? 8 : 0,
                    y: isInputFocused ? 2 : 0
                )

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
                .opacity(isValidAPIKey ? (isButtonHovered ? 0.9 : 1.0) : 0.5)
                .scaleEffect(isButtonHovered && isValidAPIKey ? 1.02 : 1.0)
                .shadow(
                    color: isValidAPIKey ? DesignTokens.Colors.accentPrimary.opacity(isButtonHovered ? 0.5 : 0.3) : .clear,
                    radius: isButtonHovered && isValidAPIKey ? 12 : 8,
                    y: isButtonHovered && isValidAPIKey ? 6 : 4
                )
                .focused($isSubmitFocused)
                .keyboardShortcut(.defaultAction)
                .onHover { hovering in
                    isButtonHovered = hovering
                }
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
        .animation(.appSpring(reduceMotion: reduceMotion), value: isButtonHovered)
    }
}
