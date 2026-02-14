//
//  AlertHistoryManagerTests.swift
//  minimax-usage-checkerTests
//
//  Usage Alerts Feature - Unit Tests
//

import Foundation
import Testing
@testable import minimax_usage_checker

@MainActor
struct AlertHistoryManagerTests {
    
    @Test func testAlertHistoryEntryInitialization() {
        let entry = AlertHistoryEntry(
            modelName: "test-model",
            usagePercentage: 85.0,
            alertType: .warning
        )
        
        #expect(entry.modelName == "test-model")
        #expect(entry.usagePercentage == 85.0)
        #expect(entry.alertType == .warning)
        #expect(entry.id != UUID())
        #expect(entry.timestamp != nil)
    }
    
    @Test func testAlertHistoryEntryWithCustomValues() {
        let customId = UUID()
        let customTimestamp = Date(timeIntervalSince1970: 1700000000)
        
        let entry = AlertHistoryEntry(
            id: customId,
            modelName: "custom-model",
            usagePercentage: 95.0,
            alertType: .critical,
            timestamp: customTimestamp
        )
        
        #expect(entry.id == customId)
        #expect(entry.modelName == "custom-model")
        #expect(entry.usagePercentage == 95.0)
        #expect(entry.alertType == .critical)
        #expect(entry.timestamp == customTimestamp)
    }
    
    @Test func testAlertHistoryEntryCodableRoundTrip() throws {
        let original = AlertHistoryEntry(
            modelName: "test-model",
            usagePercentage: 88.5,
            alertType: .warning
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(AlertHistoryEntry.self, from: data)
        
        #expect(decoded.modelName == original.modelName)
        #expect(decoded.usagePercentage == original.usagePercentage)
        #expect(decoded.alertType == original.alertType)
    }
    
    @Test func testAlertTypeDisplayNames() {
        #expect(AlertType.warning.displayName == "Warning")
        #expect(AlertType.critical.displayName == "Critical")
    }
    
    @Test func testAlertTypeIconNames() {
        #expect(AlertType.warning.iconName == "exclamationmark.triangle.fill")
        #expect(AlertType.critical.iconName == "xmark.octagon.fill")
    }
    
    @Test func testSnoozeDurationSeconds() {
        #expect(SnoozeDuration.fifteenMinutes.seconds == 15 * 60)
        #expect(SnoozeDuration.oneHour.seconds == 60 * 60)
        #expect(SnoozeDuration.fourHours.seconds == 4 * 60 * 60)
        #expect(SnoozeDuration.twentyFourHours.seconds == 24 * 60 * 60)
    }
    
    @Test func testSnoozeDurationDisplayNames() {
        #expect(SnoozeDuration.fifteenMinutes.displayName == "15 minutes")
        #expect(SnoozeDuration.oneHour.displayName == "1 hour")
        #expect(SnoozeDuration.fourHours.displayName == "4 hours")
        #expect(SnoozeDuration.twentyFourHours.displayName == "24 hours")
    }
    
    @Test func testValidationErrorMessages() {
        #expect(ValidationError.warningTooLow.errorDescription == "Warning threshold must be at least 10%")
        #expect(ValidationError.warningTooHigh.errorDescription == "Warning threshold must be at most 99%")
        #expect(ValidationError.criticalTooLow.errorDescription == "Critical threshold must be at least 5%")
        #expect(ValidationError.criticalTooHigh.errorDescription == "Critical threshold must be at most 95%")
        #expect(ValidationError.warningMustExceedCritical.errorDescription == "Warning threshold must be greater than critical threshold")
        #expect(ValidationError.modelNotFound.errorDescription == "Model not found")
    }
    
    @Test func testModelAlertSettingsDefaultValues() {
        let settings = ModelAlertSettings(
            warningThreshold: 80.0,
            criticalThreshold: 90.0,
            isEnabled: true
        )
        
        #expect(settings.warningThreshold == 80.0)
        #expect(settings.criticalThreshold == 90.0)
        #expect(settings.isEnabled == true)
    }
    
    @Test func testModelAlertSettingsCodableRoundTrip() throws {
        let original = ModelAlertSettings(
            warningThreshold: 75.0,
            criticalThreshold: 95.0,
            isEnabled: false
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(ModelAlertSettings.self, from: data)
        
        #expect(decoded.warningThreshold == 75.0)
        #expect(decoded.criticalThreshold == 95.0)
        #expect(decoded.isEnabled == false)
    }
}
