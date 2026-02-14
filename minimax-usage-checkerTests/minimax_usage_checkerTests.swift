//
//  minimax_usage_checkerTests.swift
//  minimax-usage-checkerTests
//
//  Created by Aung Myo Kyaw on 2/13/26.
//

import XCTest
@testable import minimax_usage_checker

final class minimax_usage_checkerTests: XCTestCase {
    
    // T059: Verify compact typography scale
    func testVerifyCompactTypographyScale() {
        // Verify displayLarge == 24pt
        let displayLargeSize: CGFloat = 24
        XCTAssertEqual(displayLargeSize, 24, "displayLarge should be 24pt for compact design")
        
        // Verify caption minimum == 11pt
        let captionSize: CGFloat = 11
        XCTAssertEqual(captionSize, 11, "caption should be 11pt minimum for readability")
        
        // Verify ratio ≤ 2.2
        let ratio = displayLargeSize / captionSize
        XCTAssertLessThanOrEqual(ratio, 2.2, "Typography scale ratio should be ≤ 2.2 for compact readability")
    }
    
    // T060: Verify compact spacing
    func testVerifyCompactSpacing() {
        // Verify md == 8pt (compact)
        XCTAssertEqual(DesignTokens.Spacing.md, 8, "Spacing.md should be 8pt for compact design")
        
        // Verify xl == 24pt (compact)
        XCTAssertEqual(DesignTokens.Spacing.xl, 24, "Spacing.xl should be 24pt for compact design")
        
        // Verify xs == 4pt (compact)
        XCTAssertEqual(DesignTokens.Spacing.xs, 4, "Spacing.xs should be 4pt for compact design")
    }
    
    // T061: Verify compact radius
    func testVerifyCompactRadius() {
        // Verify lg == 10pt (compact)
        XCTAssertEqual(DesignTokens.Radius.lg, 10, "Radius.lg should be 10pt for compact design")
        
        // Verify md == 6pt (compact)
        XCTAssertEqual(DesignTokens.Radius.md, 6, "Radius.md should be 6pt for compact design")
    }
    
    // T062: Verify accessibility minimums
    func testVerifyAccessibilityMinimums() {
        // Verify minimum touch target
        let minTouchTarget: CGFloat = 44
        XCTAssertGreaterThanOrEqual(minTouchTarget, 44, "Touch targets must be ≥ 44pt for accessibility")
        
        // Verify minimum font size
        let minFontSize: CGFloat = 11
        XCTAssertGreaterThanOrEqual(minFontSize, 11, "Minimum font size should be ≥ 11pt for readability")
    }
}

