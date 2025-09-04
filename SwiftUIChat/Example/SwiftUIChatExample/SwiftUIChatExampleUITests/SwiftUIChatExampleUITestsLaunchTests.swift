//
//  SwiftUIChatExampleUITestsLaunchTests.swift
//  SwiftUIChatExampleUITests
//
//  Created by Artur Pilavetz on 04.09.2025.
//

import XCTest

final class SwiftUIChatExampleUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
