//
//  SwiftUIChatExampleUITests.swift
//  SwiftUIChatExampleUITests
//
//  Created by Artur Pilavetz on 04.09.2025.
//

import XCTest

final class SwiftUIChatExampleUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {

	}

    @MainActor
	func testExample() throws {
		let app = XCUIApplication()
		app.launch()
	}

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
