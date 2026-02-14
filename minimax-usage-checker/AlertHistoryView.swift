import SwiftUI

struct AlertHistoryView: View {
    @ObservedObject var historyManager = AlertHistoryManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            if historyManager.history.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "bell.slash")
                        .font(DesignTokens.Typography.displayLarge)
                        .foregroundColor(.secondary)
                    
                    Text("No Alert History")
                        .font(.headline)
                    
                    Text("Alerts will appear here when your usage crosses configured thresholds.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                List {
                    ForEach(historyManager.history) { entry in
                        AlertHistoryRow(entry: entry)
                    }
                }
                .listStyle(.inset)
            }
        }
        .frame(minWidth: 400, minHeight: 300)
        .navigationTitle("Alert History")
        .toolbar {
            if !historyManager.history.isEmpty {
                ToolbarItem(placement: .primaryAction) {
                    Button("Clear") {
                        historyManager.clearHistory()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}

struct AlertHistoryRow: View {
    let entry: AlertHistoryEntry
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: entry.alertType.iconName)
                .font(.title2)
                .foregroundColor(entry.alertType == .warning ? .orange : .red)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.modelName)
                    .font(.headline)
                
                Text(entry.alertType.displayName)
                    .font(.caption)
                    .foregroundColor(entry.alertType == .warning ? .orange : .red)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.0f%% used", entry.usagePercentage))
                    .font(.subheadline)
                
                Text(entry.timestamp, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    AlertHistoryView()
}
