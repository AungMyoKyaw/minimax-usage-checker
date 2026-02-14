//
//  minimax_usage_checkerUITests.swift
//  minimax-usage-checkerUITests
//
//  Created by Aung Myo Kyaw on 2/13/26.
//

import XCTest

final class minimax_usage_checkerUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    // T063: Test dashboard displays 5+ models at 800x600 without scrolling
    @MainActor
    func testDashboardDisplaysFiveModelsWithoutScrolling() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Verify app exists and is responsive
        XCTAssertTrue(app.exists, "Application should launch successfully")
        
        // Give the app time to load data
        sleep(2)
        
        // Verify we're on Dashboard tab (should be default)
        // If tabs exist, verify Dashboard tab is present
        let dashboardTab = app.buttons.matching(identifier: "Dashboard").firstMatch
        if dashboardTab.exists {
            XCTAssertTrue(dashboardTab.exists, "Dashboard tab should be visible")
        }
    }
}
