//
//  AlertSettingsManagerTests.swift
//  minimax-usage-checkerTests
//
//  Usage Alerts Feature - Unit Tests
//

import Foundation
import Testing
@testable import minimax_usage_checker

@MainActor
struct AlertSettingsManagerTests {
    
    @Test func testDefaultSettingsHaveCorrectValues() {
        let settings = AlertSettings.defaultSettings
        
        #expect(settings.globalWarningThreshold == 85.0)
        #expect(settings.globalCriticalThreshold == 95.0)
        #expect(settings.perModelOverrides.isEmpty)
        #expect(settings.enabledModels.isEmpty)
        #expect(settings.isSnoozed == false)
        #expect(settings.snoozeEndTime == nil)
        #expect(settings.customWarningMessage == nil)
        #expect(settings.customCriticalMessage == nil)
    }
    
    @Test func testEffectiveWarningMessageUsesCustomWhenSet() {
        var settings = AlertSettings.defaultSettings
        settings.customWarningMessage = "Custom: {model} is at {percent}%"
        
        #expect(settings.effectiveWarningMessage == "Custom: {model} is at {percent}%")
    }
    
    @Test func testEffectiveWarningMessageUsesDefaultWhenNotSet() {
        let settings = AlertSettings.defaultSettings
        
        #expect(settings.effectiveWarningMessage == "MiniMax Usage Warning: {model} only {remaining} remaining ({percent}% left)")
    }
    
    @Test func testEffectiveCriticalMessageUsesCustomWhenSet() {
        var settings = AlertSettings.defaultSettings
        settings.customCriticalMessage = "Critical: {model} only {remaining} left!"
        
        #expect(settings.effectiveCriticalMessage == "Critical: {model} only {remaining} left!")
    }
    
    @Test func testEffectiveCriticalMessageUsesDefaultWhenNotSet() {
        let settings = AlertSettings.defaultSettings
        
        #expect(settings.effectiveCriticalMessage == "MiniMax Credits Low!: {model} only {remaining} remaining! Time to top up.")
    }
    
    @Test func testIsSnoozedCurrentlyReturnsFalseWhenNotSnoozed() {
        let settings = AlertSettings.defaultSettings
        
        #expect(settings.isSnoozedCurrently == false)
    }
    
    @Test func testIsSnoozedCurrentlyReturnsFalseWhenSnoozeExpired() {
        var settings = AlertSettings.defaultSettings
        settings.isSnoozed = true
        settings.snoozeEndTime = Date().addingTimeInterval(-3600) // 1 hour ago
        
        #expect(settings.isSnoozedCurrently == false)
    }
    
    @Test func testIsSnoozedCurrentlyReturnsTrueWhenSnoozed() {
        var settings = AlertSettings.defaultSettings
        settings.isSnoozed = true
        settings.snoozeEndTime = Date().addingTimeInterval(3600) // 1 hour from now
        
        #expect(settings.isSnoozedCurrently == true)
    }
    
    @Test func testEnabledModelsSetConversion() {
        var settings = AlertSettings.defaultSettings
        settings.enabledModels = ["model1", "model2"]
        
        #expect(settings.enabledModelsSet == Set(["model1", "model2"]))
    }
    
    @Test func testAlertSettingsCodableRoundTrip() throws {
        var original = AlertSettings.defaultSettings
        original.globalWarningThreshold = 80.0
        original.globalCriticalThreshold = 90.0
        original.customWarningMessage = "Test warning"
        original.customCriticalMessage = "Test critical"
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(AlertSettings.self, from: data)
        
        #expect(decoded.globalWarningThreshold == 80.0)
        #expect(decoded.globalCriticalThreshold == 90.0)
        #expect(decoded.customWarningMessage == "Test warning")
        #expect(decoded.customCriticalMessage == "Test critical")
    }
}
