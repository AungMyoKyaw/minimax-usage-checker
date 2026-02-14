# Quickstart: World-Class UI/UX Redesign Implementation

**Date**: 2026-02-14
**Feature**: 001-world-class-ui-ux

---

## Overview

This guide provides a step-by-step approach to implementing the world-class UI/UX redesign. Follow these phases in order, ensuring each is complete before moving to the next.

---

## Prerequisites

- Xcode 15.0+
- macOS 12.0+ (Monterey) deployment target
- Swift 5.9+
- Familiarity with SwiftUI

---

## Phase 1: Design System Foundation (Est. 2-3 hours)

### Step 1.1: Create Directory Structure

```bash
# In minimax-usage-checker/ directory
mkdir -p minimax-usage-checker/DesignSystem
mkdir -p minimax-usage-checker/Components
mkdir -p minimax-usage-checker/Views
```

### Step 1.2: Create Color Assets

1. Open `Assets.xcassets`
2. Create new folder `Colors`
3. Add color sets for each token:

| Color Name | Light Color | Dark Color |
|------------|-------------|------------|
| UsageSafe | #34C759 | #30D158 |
| UsageWarning | #FF9500 | #FF9F0A |
| UsageCritical | #FF3B30 | #FF453A |
| SurfacePrimary | #FFFFFF | #1C1C1E |
| SurfaceSecondary | #F2F2F7 | #2C2C2E |
| SurfaceTertiary | #E5E5EA | #3A3A3C |
| BorderSubtle | #E5E5EA | #38383A |
| BorderEmphasis | #C7C7CC | #48484A |

### Step 1.3: Create DesignTokens.swift

```swift
// DesignSystem/DesignTokens.swift
import SwiftUI

enum DesignTokens {
    enum Colors {
        static let usageSafe = Color("UsageSafe")
        static let usageWarning = Color("UsageWarning")
        static let usageCritical = Color("UsageCritical")
        static let surfacePrimary = Color("SurfacePrimary")
        static let surfaceSecondary = Color("SurfaceSecondary")
        static let surfaceTertiary = Color("SurfaceTertiary")
        static let borderSubtle = Color("BorderSubtle")
        static let borderEmphasis = Color("BorderEmphasis")
    }
    
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
    }
    
    enum Typography {
        static let displayLarge = Font.system(size: 48, weight: .bold, design: .rounded)
        static let displayMedium = Font.system(size: 32, weight: .bold, design: .rounded)
        static let headingLarge = Font.system(size: 24, weight: .semibold)
        static let headingMedium = Font.system(size: 18, weight: .semibold)
        static let bodyLarge = Font.system(size: 16, weight: .regular)
        static let bodyMedium = Font.system(size: 14, weight: .regular)
        static let caption = Font.system(size: 12, weight: .regular)
        static let captionSmall = Font.system(size: 10, weight: .regular)
    }
}
```

### Step 1.4: Create Animations.swift

```swift
// DesignSystem/Animations.swift
import SwiftUI

extension Animation {
    static let appTransition = Animation.easeInOut(duration: 0.3)
    static let appSpring = Animation.spring(response: 0.35, dampingFraction: 0.75)
    static let appSubtle = Animation.easeOut(duration: 0.2)
    static let appValue = Animation.easeInOut(duration: 0.25)
    
    static func appTransition(reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : appTransition
    }
    
    static func appSpring(reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : appSpring
    }
}
```

### Step 1.5: Create UsageStatus Helper

```swift
// DesignSystem/UsageStatus.swift
import SwiftUI

enum UsageStatus {
    case safe, warning, critical
    
    init(percentage: Double) {
        if percentage > 90 { self = .critical }
        else if percentage > 70 { self = .warning }
        else { self = .safe }
    }
    
    var color: Color {
        switch self {
        case .safe: return DesignTokens.Colors.usageSafe
        case .warning: return DesignTokens.Colors.usageWarning
        case .critical: return DesignTokens.Colors.usageCritical
        }
    }
}
```

---

## Phase 2: Core Components (Est. 4-6 hours)

### Step 2.1: CircularProgressView

```swift
// Components/CircularProgressView.swift
import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let status: UsageStatus
    var size: CGSize = CGSize(width: 120, height: 120)
    var lineWidth: CGFloat = 8
    var showPercentage: Bool = true
    
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(status.color.opacity(0.15), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    status.color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.appValue(reduceMotion: reduceMotion), value: progress)
            
            if showPercentage {
                VStack(spacing: 2) {
                    Text("\(Int(progress * 100))")
                        .font(DesignTokens.Typography.displayMedium)
                    Text("% used")
                        .font(DesignTokens.Typography.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(width: size.width, height: size.height)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Usage progress")
        .accessibilityValue("\(Int(progress * 100)) percent used")
    }
}
```

### Step 2.2: LinearProgressView

```swift
// Components/LinearProgressView.swift
import SwiftUI

struct LinearProgressView: View {
    let progress: Double
    let status: UsageStatus
    var height: CGFloat = 8
    
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
```

### Step 2.3: StatCard

```swift
// Components/StatCard.swift
import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let status: UsageStatus
    
    @State private var isHovered = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(status.color)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(DesignTokens.Typography.headingLarge)
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(title)
                .font(DesignTokens.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                .fill(DesignTokens.Colors.surfacePrimary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                .stroke(status.color.opacity(0.2), lineWidth: 1)
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .shadow(radius: isHovered ? 12 : 8)
        .animation(.appSubtle(reduceMotion: reduceMotion), value: isHovered)
        .onHover { isHovered = $0 }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value) \(subtitle)")
    }
}
```

### Step 2.4: EmptyStateView

```swift
// Components/EmptyStateView.swift
import SwiftUI

struct EmptyStateView: View {
    let type: EmptyStateType
    var action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
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
                
                Image(systemName: type.icon)
                    .font(.system(size: 40))
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: DesignTokens.Spacing.sm) {
                Text(type.title)
                    .font(DesignTokens.Typography.headingMedium)
                    .fontWeight(.semibold)
                
                Text(type.message)
                    .font(DesignTokens.Typography.bodyMedium)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 280)
            }
            
            if let action = action {
                Button(action: action) {
                    Text("Get Started")
                        .fontWeight(.semibold)
                        .frame(maxWidth: 200)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
```

---

## Phase 3: Views (Est. 6-8 hours)

### Step 3.1: OnboardingView

```swift
// Views/OnboardingView.swift
import SwiftUI

struct OnboardingView: View {
    @Binding var apiKey: String
    let onSubmit: () -> Void
    
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.xxl) {
            Spacer()
            
            // Brand
            VStack(spacing: DesignTokens.Spacing.lg) {
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
                .shadow(color: Color.accentColor.opacity(0.3), radius: 20)
                
                VStack(spacing: DesignTokens.Spacing.sm) {
                    Text("MiniMax Usage")
                        .font(DesignTokens.Typography.displayMedium)
                    
                    Text("Track your AI usage in real-time")
                        .font(DesignTokens.Typography.bodyMedium)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Input
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
                .disabled(apiKey.isEmpty)
                .shadow(color: Color.accentColor.opacity(0.3), radius: 8, y: 4)
            }
            
            Text("Your API key is stored locally and never leaves your device")
                .font(DesignTokens.Typography.captionSmall)
                .foregroundStyle(.tertiary)
            
            Spacer()
        }
        .padding()
        .onAppear { isInputFocused = true }
    }
}
```

### Step 3.2: DashboardView

```swift
// Views/DashboardView.swift
import SwiftUI
import Charts

struct DashboardView: View {
    @ObservedObject var viewModel: UsageViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                // Primary indicator
                if let mostUrgent = viewModel.mostUrgentModel {
                    PrimaryUsageCard(model: mostUrgent)
                }
                
                // Stats grid
                StatsGrid(viewModel: viewModel)
                
                // Usage chart
                if !viewModel.dailyUsageData.isEmpty {
                    UsageChartView(data: viewModel.dailyUsageData)
                }
                
                // Model status list
                ModelStatusList(models: viewModel.modelRemains)
            }
            .padding(DesignTokens.Spacing.lg)
        }
        .background(DesignTokens.Colors.surfaceTertiary.opacity(0.5))
    }
}
```

---

## Phase 4: Integration (Est. 2-3 hours)

### Step 4.1: Update ContentView

Replace existing ContentView with new structure:

```swift
// ContentView.swift
struct ContentView: View {
    @StateObject private var viewModel = UsageViewModel()
    @State private var enteredAPIKey: String = ""
    
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
                            viewModel.startAutoRefresh()
                            Task { await viewModel.fetchUsage() }
                        }
                    )
                }
            }
            .navigationTitle("MiniMax Usage")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    if viewModel.hasAPIKey {
                        Button("Logout", systemImage: "rectangle.portrait.and.arrow.right") {
                            viewModel.clearAPIKey()
                        }
                    }
                }
            }
        }
        .onAppear {
            enteredAPIKey = viewModel.apiKey
            if viewModel.hasAPIKey {
                viewModel.startAutoRefresh()
            }
        }
    }
}
```

### Step 4.2: Run Tests

```bash
# Build and test
xcodebuild test -project minimax-usage-checker.xcodeproj -scheme minimax-usage-checker

# Or run in Xcode: Cmd + U
```

---

## Verification Checklist

After completing implementation, verify:

- [ ] All color tokens defined in Asset Catalog
- [ ] DesignTokens.swift compiles without errors
- [ ] CircularProgressView animates smoothly
- [ ] LinearProgressView shows correct status colors
- [ ] StatCards respond to hover
- [ ] Empty states display correctly
- [ ] Tab transitions are smooth
- [ ] Reduce Motion preference is respected
- [ ] VoiceOver announces all elements correctly
- [ ] App builds and runs on macOS 12+
- [ ] Dark mode colors are correct
- [ ] All animations complete within 400ms

---

## Next Steps

1. **Create tasks**: Run `/speckit.tasks` to break this plan into actionable tasks
2. **Start implementation**: Begin with Phase 1 (Design System)
3. **Iterate**: Test each component before moving to the next phase
4. **Review**: Use the component checklist in [components.md](./contracts/components.md) to track progress
