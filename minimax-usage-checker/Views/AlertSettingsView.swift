import SwiftUI

struct AlertSettingsView: View {
    @ObservedObject var settingsManager = AlertSettingsManager.shared
    
    @State private var warningThreshold: Double = 85.0
    @State private var criticalThreshold: Double = 95.0
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var showingSnoozeSheet = false
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Alert Thresholds")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Warning Threshold")
                            Spacer()
                            Text("\(Int(warningThreshold))%")
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $warningThreshold, in: 10...99, step: 1) {
                            Text("Warning Threshold")
                        }
                        .onChange(of: warningThreshold) { _, newValue in
                            saveThresholds()
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Critical Threshold")
                            Spacer()
                            Text("\(Int(criticalThreshold))%")
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $criticalThreshold, in: 5...95, step: 1) {
                            Text("Critical Threshold")
                        }
                        .onChange(of: criticalThreshold) { _, newValue in
                            saveThresholds()
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            
            Section {
                HStack {
                    Image(systemName: settingsManager.settings.isSnoozedCurrently ? "bell.slash.fill" : "bell.fill")
                        .foregroundColor(settingsManager.settings.isSnoozedCurrently ? .red : .green)
                    
                    VStack(alignment: .leading) {
                        Text("Alert Status")
                            .font(.headline)
                        if settingsManager.settings.isSnoozedCurrently, let endTime = settingsManager.settings.snoozeEndTime {
                            Text("Snoozed until \(endTime, style: .time)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            Text("Active")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Button(settingsManager.settings.isSnoozedCurrently ? "Unsnooze" : "Snooze") {
                        if settingsManager.settings.isSnoozedCurrently {
                            settingsManager.unsnooze()
                        } else {
                            showingSnoozeSheet = true
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            Section {
                CustomMessageView()
            }
        }
        .formStyle(.grouped)
        .frame(minWidth: 400, minHeight: 300)
        .onAppear {
            loadThresholds()
        }
        .alert("Invalid Configuration", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .sheet(isPresented: $showingSnoozeSheet) {
            SnoozeOptionsView()
        }
    }
    
    private func loadThresholds() {
        warningThreshold = settingsManager.settings.globalWarningThreshold
        criticalThreshold = settingsManager.settings.globalCriticalThreshold
    }
    
    private func saveThresholds() {
        do {
            try settingsManager.setGlobalWarningThreshold(warningThreshold)
            try settingsManager.setGlobalCriticalThreshold(criticalThreshold)
        } catch let error as ValidationError {
            errorMessage = error.localizedDescription ?? "Unknown error"
            showingError = true
            loadThresholds()
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
            loadThresholds()
        }
    }
}

struct SnoozeOptionsView: View {
    @ObservedObject var settingsManager = AlertSettingsManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Snooze Alerts")
                .font(.headline)
            
            ForEach(SnoozeDuration.allCases) { duration in
                Button(duration.displayName) {
                    do {
                        try settingsManager.snooze(duration: duration)
                        dismiss()
                    } catch {
                        print("Error snoozing: \(error)")
                    }
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.bordered)
            }
            
            Button("Cancel", role: .cancel) {
                dismiss()
            }
            .buttonStyle(.bordered)
        }
        .padding(30)
        .frame(width: 300)
    }
}

#Preview {
    AlertSettingsView()
}
