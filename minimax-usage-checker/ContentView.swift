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

    // MARK: - API Key Input View

    private var apiKeyInputView: some View {
        VStack(spacing: 24) {
            Image(systemName: "key.fill")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)

            Text("Enter Your API Key")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Your API key will be stored locally on this device.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            SecureField("API Key", text: $enteredAPIKey)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 400)

            Button(action: {
                viewModel.saveAPIKey(enteredAPIKey)
                viewModel.startAutoRefresh(interval: 30)
            }) {
                Text("Save & Continue")
                    .frame(maxWidth: 200)
            }
            .buttonStyle(.borderedProminent)
            .disabled(enteredAPIKey.isEmpty)

            Spacer()
        }
        .padding()
    }

    // MARK: - Usage View

    private var usageView: some View {
        VStack(spacing: 0) {
            // Header with last updated
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

            Divider()

            // Error Message
            if let error = viewModel.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(error)
                        .font(.callout)
                        .foregroundColor(.red)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.1))
            }

            // Usage Cards
            if viewModel.modelRemains.isEmpty && viewModel.errorMessage == nil && !viewModel.isLoading {
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    Text("No usage data available")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    }
}

// MARK: - Model Usage Card

struct ModelUsageCard: View {
    let model: ModelRemain

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text(model.modelName)
                    .font(.headline)
                Spacer()
                Text(model.remainsTimeFormatted + " remaining")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Progress Bar
            VStack(alignment: .leading, spacing: 4) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 12)

                        RoundedRectangle(cornerRadius: 6)
                            .fill(progressColor)
                            .frame(width: geometry.size.width * CGFloat(model.usagePercentage / 100), height: 12)
                    }
                }
                .frame(height: 12)

                HStack {
                    Text("\(model.usedPrompts) / \(model.currentIntervalTotalCount) prompts")
                    Spacer()
                    Text(String(format: "%.1f%%", model.usagePercentage))
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }

            // Time Window
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.secondary)
                Text("Window: \(model.windowTimeRange)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(12)
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
}

#Preview {
    ContentView()
}
