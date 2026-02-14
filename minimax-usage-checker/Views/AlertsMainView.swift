import SwiftUI

struct AlertsMainView: View {
    @State private var selectedAlertTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Button(action: { selectedAlertTab = 0 }) {
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        Image(systemName: "gear")
                            .font(.system(size: 14))
                        Text("Settings")
                            .font(DesignTokens.Typography.bodyMedium)
                            .fontWeight(selectedAlertTab == 0 ? .semibold : .regular)
                    }
                    .foregroundStyle(selectedAlertTab == 0 ? .white : DesignTokens.Colors.textSecondary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                            .fill(selectedAlertTab == 0 ? DesignTokens.Colors.accentPrimary : Color.clear)
                    )
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                Button(action: { selectedAlertTab = 1 }) {
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 14))
                        Text("History")
                            .font(DesignTokens.Typography.bodyMedium)
                            .fontWeight(selectedAlertTab == 1 ? .semibold : .regular)
                    }
                    .foregroundStyle(selectedAlertTab == 1 ? .white : DesignTokens.Colors.textSecondary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                            .fill(selectedAlertTab == 1 ? DesignTokens.Colors.accentPrimary : Color.clear)
                    )
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
            .padding(.horizontal, DesignTokens.Spacing.md)
            .padding(.vertical, DesignTokens.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .fill(DesignTokens.Colors.surfaceSecondary)
            )
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.top, DesignTokens.Spacing.md)
            
            Group {
                if selectedAlertTab == 0 {
                    AlertSettingsView()
                } else {
                    AlertHistoryView()
                }
            }
        }
        .background(DesignTokens.Colors.surfaceTertiary.opacity(0.5))
    }
}

#Preview {
    AlertsMainView()
}
