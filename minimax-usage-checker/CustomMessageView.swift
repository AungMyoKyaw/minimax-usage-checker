import SwiftUI

struct CustomMessageView: View {
    @ObservedObject var settingsManager = AlertSettingsManager.shared
    
    @State private var warningMessage: String = ""
    @State private var criticalMessage: String = ""
    @State private var enableCustomMessages: Bool = false
    
    private let warningPlaceholder = "MiniMax Usage Warning: {model} only {remaining} remaining ({percent}% left)"
    private let criticalPlaceholder = "MiniMax Credits Low!: {model} only {remaining} remaining! Time to top up."
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Toggle("Enable Custom Messages", isOn: $enableCustomMessages)
                .onChange(of: enableCustomMessages) { _, newValue in
                    if !newValue {
                        clearCustomMessages()
                    } else {
                        loadCurrentMessages()
                    }
                }
            
            if enableCustomMessages {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Warning Message")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("Warning message template", text: $warningMessage, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...5)
                    
                    Text("Variables: {model}, {remaining}, {percent}")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Critical Message")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("Critical message template", text: $criticalMessage, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...5)
                    
                    Text("Variables: {model}, {remaining}, {percent}")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Button("Reset to Default") {
                        warningMessage = warningPlaceholder
                        criticalMessage = criticalPlaceholder
                        saveMessages()
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    Button("Preview Warning") {
                        previewMessage(warningMessage.isEmpty ? warningPlaceholder : warningMessage, type: .warning)
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Preview Critical") {
                        previewMessage(criticalMessage.isEmpty ? criticalPlaceholder : criticalMessage, type: .critical)
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Default Warning Message:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(warningPlaceholder)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textSelection(.enabled)
                    
                    Text("Default Critical Message:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                    Text(criticalPlaceholder)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textSelection(.enabled)
                }
            }
        }
        .padding(.vertical, 8)
        .onAppear {
            loadCurrentMessages()
            enableCustomMessages = settingsManager.settings.customWarningMessage != nil || settingsManager.settings.customCriticalMessage != nil
        }
    }
    
    private func loadCurrentMessages() {
        warningMessage = settingsManager.settings.customWarningMessage ?? warningPlaceholder
        criticalMessage = settingsManager.settings.customCriticalMessage ?? criticalPlaceholder
    }
    
    private func saveMessages() {
        let warning = warningMessage == warningPlaceholder ? nil : warningMessage
        let critical = criticalMessage == criticalPlaceholder ? nil : criticalMessage
        settingsManager.setCustomMessages(warning: warning, critical: critical)
    }
    
    private func clearCustomMessages() {
        settingsManager.setCustomMessages(warning: nil, critical: nil)
    }
    
    private func previewMessage(_ template: String, type: AlertType) {
        let sampleModel = "abab6.5s-chat"
        let sampleRemaining = "1,000 tokens"
        let samplePercent = type == .warning ? "15" : "5"
        
        var message = template
        message = message.replacingOccurrences(of: "{model}", with: sampleModel)
        message = message.replacingOccurrences(of: "{remaining}", with: sampleRemaining)
        message = message.replacingOccurrences(of: "{percent}", with: samplePercent)
        
        let alert = NSAlert()
        alert.messageText = type == .warning ? "Warning Message Preview" : "Critical Message Preview"
        alert.informativeText = message
        alert.alertStyle = type == .warning ? .warning : .critical
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}

#Preview {
    CustomMessageView()
        .padding()
        .frame(width: 500)
}
