//
//  ContentView.swift
//  minimax-usage-checker
//
//  Created by Aung Myo Kyaw on 2/13/26.
//

import SwiftUI
import Charts

struct ContentView: View {
    @StateObject private var viewModel = UsageViewModel()
    @State private var enteredAPIKey: String = ""
    @State private var selectedTab: Tab = .dashboard

    enum Tab: String, CaseIterable {
        case dashboard = "Dashboard"
        case usage = "Usage"
        case history = "History"
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.hasAPIKey {
                    mainContent
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
            if viewModel.hasAPIKey {
                viewModel.startAutoRefresh(interval: 30)
            }
        }
    }

    private var mainContent: some View {
        VStack(spacing: 0) {
            TabPicker
                .padding()
                .background(Color(.windowBackgroundColor))
            
            Divider()
            
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var TabPicker: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: tabIcon(for: tab))
                            .font(.system(size: 14, weight: .medium))
                        Text(tab.rawValue)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        selectedTab == tab
                            ? Color.accentColor.opacity(0.15)
                            : Color.clear
                    )
                    .foregroundColor(selectedTab == tab ? .accentColor : .secondary)
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
            Spacer()
            
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(0.7)
            } else {
                Button(action: {
                    Task {
                        await viewModel.fetchUsage()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 14, weight: .medium))
                }
                .buttonStyle(.borderless)
            }
        }
    }

    private func tabIcon(for tab: Tab) -> String {
        switch tab {
        case .dashboard: return "chart.bar.fill"
        case .usage: return "cpu"
        case .history: return "clock.arrow.circlepath"
        }
    }

    private var apiKeyInputView: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.accentColor.opacity(0.4), Color.accentColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 48))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.accentColor, Color.accentColor.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: Color.accentColor.opacity(0.3), radius: 20, x: 0, y: 10)
                
                VStack(spacing: 8) {
                    Text("MiniMax Usage")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                    
                    Text("Track your AI usage in real-time with beautiful analytics")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 320)
                }
            }

            VStack(spacing: 20) {
                CustomTextField(placeholder: "API Key", text: $enteredAPIKey, isSecure: true)
                    .frame(maxWidth: 400)

                Button(action: {
                    viewModel.saveAPIKey(enteredAPIKey)
                    viewModel.startAutoRefresh(interval: 30)
                    Task {
                        await viewModel.fetchUsage()
                    }
                }) {
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
                .disabled(enteredAPIKey.isEmpty)
                .shadow(color: Color.accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
            }

            Text("Your API key is stored locally and never leaves your device")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding()
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .textFieldStyle(.plain)
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

struct DashboardView: View {
    @ObservedObject var viewModel: UsageViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                StatsOverview(viewModel: viewModel)
                
                if !viewModel.modelRemains.isEmpty {
                    UsageChart(viewModel: viewModel)
                }
                
                if !viewModel.modelRemains.isEmpty {
                    QuickStats(viewModel: viewModel)
                }
            }
            .padding(24)
        }
        .background(Color(.windowBackgroundColor).opacity(0.5))
    }
}

struct StatsOverview: View {
    @ObservedObject var viewModel: UsageViewModel

    var body: some View {
        HStack(spacing: 16) {
            StatCard(
                title: "Total Used",
                value: "\(viewModel.totalUsedPrompts)",
                subtitle: "prompts",
                icon: "arrow.up.circle.fill",
                color: .blue
            )
            
            StatCard(
                title: "Remaining",
                value: "\(viewModel.totalRemainingPrompts)",
                subtitle: "prompts",
                icon: "arrow.down.circle.fill",
                color: .green
            )
            
            StatCard(
                title: "Avg Usage",
                value: String(format: "%.1f%%", viewModel.averageUsagePercentage),
                subtitle: "of quota",
                icon: "chart.pie.fill",
                color: .orange
            )
            
            StatCard(
                title: "Models",
                value: "\(viewModel.modelRemains.count)",
                subtitle: "active",
                icon: "cpu.fill",
                color: .purple
            )
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(color)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}

struct UsageChart: View {
    @ObservedObject var viewModel: UsageViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Usage Trend")
                .font(.headline)
                .foregroundStyle(.primary)
            
            if viewModel.dailyUsageData.isEmpty {
                EmptyChartPlaceholder()
            } else {
                Chart(viewModel.dailyUsageData) { day in
                    BarMark(
                        x: .value("Date", day.date, unit: .day),
                        y: .value("Usage", day.usedCount)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.accentColor, Color.accentColor.opacity(0.6)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(4)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        if let date = value.as(Date.self) {
                            AxisValueLabel {
                                Text(date, format: .dateTime.day().month(.abbreviated))
                                    .font(.caption2)
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 200)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.controlBackgroundColor))
        )
    }
}

struct EmptyChartPlaceholder: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 40))
                .foregroundStyle(.secondary.opacity(0.5))
            Text("No historical data yet")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("Usage data will appear here over time")
                .font(.caption)
                .foregroundStyle(.secondary.opacity(0.7))
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
    }
}

struct QuickStats: View {
    @ObservedObject var viewModel: UsageViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Current Status")
                .font(.headline)
                .foregroundStyle(.primary)
            
            ForEach(viewModel.modelRemains) { model in
                ModelStatusRow(model: model)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.controlBackgroundColor))
        )
    }
}

struct ModelStatusRow: View {
    let model: ModelRemain

    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(statusColor)
                .frame(width: 10, height: 10)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(model.modelName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(model.windowTimeRange)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(model.remainsTimeFormatted)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(statusColor)
                Text("remaining")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }

    private var statusColor: Color {
        if model.usagePercentage > 90 {
            return .red
        } else if model.usagePercentage > 70 {
            return .orange
        } else {
            return .green
        }
    }
}

struct UsageView: View {
    @ObservedObject var viewModel: UsageViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.modelRemains) { model in
                    ModelUsageCard(model: model)
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .opacity
                        ))
                }
            }
            .padding(24)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.modelRemains.count)
        }
        .background(Color(.windowBackgroundColor).opacity(0.5))
    }
}

struct HistoryView: View {
    @ObservedObject var viewModel: UsageViewModel

    var body: some View {
        VStack(spacing: 0) {
            TimeRangePicker(selectedRange: $viewModel.selectedTimeRange)
                .padding()
                .onChange(of: viewModel.selectedTimeRange) { _, _ in
                    viewModel.loadFilteredSnapshots()
                }
            
            Divider()
            
            if viewModel.snapshots.isEmpty {
                EmptyHistoryView()
            } else {
                HistoryList(snapshots: viewModel.filteredSnapshots)
            }
        }
        .background(Color(.windowBackgroundColor).opacity(0.5))
    }
}

struct TimeRangePicker: View {
    @Binding var selectedRange: TimeRange

    var body: some View {
        HStack(spacing: 8) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedRange = range
                    }
                }) {
                    Text(range.rawValue)
                        .font(.system(size: 13, weight: .medium))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            selectedRange == range
                                ? Color.accentColor
                                : Color(.controlBackgroundColor)
                        )
                        .foregroundColor(
                            selectedRange == range ? .white : .secondary
                        )
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
    }
}

struct EmptyHistoryView: View {
    var body: some View {
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
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 40))
                    .foregroundStyle(.secondary)
            }
            VStack(spacing: 8) {
                Text("No history yet")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("Your usage history will appear here as data is collected")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 280)
            }
            Spacer()
        }
    }
}

struct HistoryList: View {
    let snapshots: [SnapshotData]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(groupedSnapshots, id: \.key) { date, items in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(formatDate(date))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                        
                        ForEach(items, id: \.timestamp) { snapshot in
                            HistoryRow(snapshot: snapshot)
                                .padding(.horizontal, 24)
                        }
                    }
                }
            }
            .padding(.bottom, 24)
        }
    }

    private var groupedSnapshots: [(key: Date, value: [SnapshotData])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: snapshots) { snapshot in
            calendar.startOfDay(for: snapshot.timestamp)
        }
        return grouped.sorted { $0.key > $1.key }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateFormat = "EEEE, MMM d"
            return formatter.string(from: date)
        }
    }
}

struct HistoryRow: View {
    let snapshot: SnapshotData

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(snapshot.modelName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(snapshot.remainsTimeFormatted + " remaining")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(snapshot.usedCount)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text("used")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                UsageBadge(percentage: snapshot.usagePercentage)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.controlBackgroundColor))
        )
    }
}

struct UsageBadge: View {
    let percentage: Double

    var body: some View {
        Text(String(format: "%.0f%%", percentage))
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(badgeColor.opacity(0.15))
            .foregroundStyle(badgeColor)
            .cornerRadius(6)
    }

    private var badgeColor: Color {
        if percentage > 90 {
            return .red
        } else if percentage > 70 {
            return .orange
        } else {
            return .green
        }
    }
}

struct ModelUsageCard: View {
    let model: ModelRemain

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(progressColor.opacity(0.15))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "brain.head.profile")
                                .font(.system(size: 18))
                                .foregroundStyle(progressColor)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(model.modelName)
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text("Window: \(model.windowTimeRange)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(model.remainsTimeFormatted)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(progressColor)
                    Text("remaining")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 12)

                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [progressColor, progressColor.opacity(0.6)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * CGFloat(model.usagePercentage / 100), height: 12)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: model.usagePercentage)
                    }
                }
                .frame(height: 12)

                HStack {
                    Label("\(model.usedPrompts) used", systemImage: "arrow.up.circle")
                    Spacer()
                    Label("\(model.remainingPrompts) left", systemImage: "arrow.down.circle")
                    Spacer()
                    Text(String(format: "%.1f%%", model.usagePercentage))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(progressColor)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.controlBackgroundColor))
                .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(progressColor.opacity(0.15), lineWidth: 1)
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
}

#Preview {
    ContentView()
}
