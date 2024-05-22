//
//  PollexaUITests.swift
//  PollexaUITests
//
//  Created by Fikret Onur ÖZDİL on 27.05.2024.
//

import XCTest

final class PollexaUITests: XCTestCase {

    override func setUpWithError() throws {
        let app = XCUIApplication()
        app.launch()

        continueAfterFailure = false
    }

    override func tearDownWithError() throws {

    }

    func testVotePressed() throws {
        XCUIApplication().collectionViews.cells.matching(identifier: "VoteCell").otherElements.containing(.staticText, identifier:"300 Total Votes").children(matching: .other).element(boundBy: 4)/*@START_MENU_TOKEN@*/.buttons["ThumbsUp"]/*[[".buttons[\"Like\"]",".buttons[\"ThumbsUp\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }

    func testNextButtonPressed() throws {
        XCUIApplication()/*@START_MENU_TOKEN@*/.staticTexts["􀄍"]/*[[".buttons[\"􀄍\"].staticTexts[\"􀄍\"]",".staticTexts[\"􀄍\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }

    func testAddButtonPressed() throws {
        XCUIApplication().navigationBars["Discover"].buttons["Add"].tap()
    }

    func testAvatarButtonPressed() throws {
        XCUIApplication().navigationBars["Discover"]/*@START_MENU_TOKEN@*/.buttons["avatarButton"]/*[[".buttons[\"avatar 1\"]",".buttons[\"avatarButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
}
