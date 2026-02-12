//
//  ContentView.swift
//  minimax-usage-checker
//
//  Created by Aung Myo Kyaw on 2/13/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UsageViewModel()
    @State private var enteredAPIKey: String = ""

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.hasAPIKey {
                    usageView
                } else {
                    apiKeyInputView
                }
            }
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
        }
    }

    private var apiKeyInputView: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.accentColor.opacity(0.3), Color.accentColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "key.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.accentColor)
                }
                
                VStack(spacing: 8) {
                    Text("MiniMax Usage")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    
                    Text("Enter your API key to start tracking your AI usage in real-time")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 300)
                }
            }

            VStack(spacing: 16) {
                SecureField("API Key", text: $enteredAPIKey)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color(.controlBackgroundColor))
                    .cornerRadius(12)
                    .frame(maxWidth: 360)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )

                Button(action: {
                    viewModel.saveAPIKey(enteredAPIKey)
                    viewModel.startAutoRefresh(interval: 30)
                }) {
                    HStack {
                        Text("Get Started")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .frame(maxWidth: 360)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(enteredAPIKey.isEmpty)
            }

            Text("Your API key is stored locally and never leaves your device")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
    }

    // MARK: - Usage View

    private var usageView: some View {
        VStack(spacing: 0) {
            headerView
            Divider()
            contentView
        }
    }

    private var headerView: some View {
        HStack {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(0.8)
                Text("Refreshing...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("Auto-refresh every 30s")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: {
                Task {
                    await viewModel.fetchUsage()
                }
            }) {
                Label("Refresh", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderless)
        }
        .padding()
        .background(Color(.windowBackgroundColor))
    }

    @ViewBuilder
    private var contentView: some View {
        if let error = viewModel.errorMessage {
            errorView(error)
        } else if viewModel.modelRemains.isEmpty && !viewModel.isLoading {
            emptyStateView
        } else {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.modelRemains) { model in
                        ModelUsageCard(model: model)
                    }
                }
                .padding()
            }
        }
    }

    private func errorView(_ error: String) -> some View {
        VStack(spacing: 20) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.15))
                    .frame(width: 80, height: 80)
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.red)
            }
            VStack(spacing: 8) {
                Text("Something went wrong")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(error)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 280)
            }
            Button(action: {
                Task {
                    await viewModel.fetchUsage()
                }
            }) {
                Label("Try Again", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.accentColor.opacity(0.2), Color.accentColor.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                Image(systemName: "chart.bar.doc.horizontal")
                    .font(.system(size: 40))
                    .foregroundColor(.accentColor)
            }
            VStack(spacing: 8) {
                Text("No usage data yet")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("Your MiniMax usage will appear here once data is available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 280)
            }
            Button(action: {
                Task {
                    await viewModel.fetchUsage()
                }
            }) {
                Label("Fetch Now", systemImage: "arrow.down.circle")
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
    }
}

// MARK: - Model Usage Card

struct ModelUsageCard: View {
    let model: ModelRemain

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(model.modelName)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text("Window: \(model.windowTimeRange)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(model.remainsTimeFormatted)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(remainingColor)
                    Text("remaining")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 16)

                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [progressColor, progressColor.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * CGFloat(model.usagePercentage / 100), height: 16)
                    }
                }
                .frame(height: 16)

                HStack {
                    Label("\(model.usedPrompts) used", systemImage: "arrow.up.circle")
                    Spacer()
                    Label("\(model.remainingPrompts) left", systemImage: "arrow.down.circle")
                    Spacer()
                    Text(String(format: "%.1f%%", model.usagePercentage))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(progressColor)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.controlBackgroundColor))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }

    private var progressColor: Color {
        if model.usagePercentage > 90 {
            return .red
        } else if model.usagePercentage > 70 {
            return .orange
        } else {
            return .accentColor
        }
    }

    private var remainingColor: Color {
        if model.usagePercentage > 90 {
            return .red
        } else if model.usagePercentage > 70 {
            return .orange
        } else {
            return .primary
        }
    }
}

#Preview {
    ContentView()
}
