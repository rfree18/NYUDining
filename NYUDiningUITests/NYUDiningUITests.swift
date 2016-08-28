//
//  NYUDiningUITests.swift
//  NYUDiningUITests
//
//  Created by Ross Freeman on 8/21/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import XCTest

class NYUDiningUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    
    func testSnapshot() {
        snapshot("Home")
        XCUIApplication().tables.staticTexts["Palladium by LifeWorks"].tap()
        snapshot("Details Page")
        XCUIApplication().buttons["Menu"].tap()
        snapshot("Menu Page")
        
        let app = XCUIApplication()
        app.navigationBars["Menu"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
        app.navigationBars["Palladium by LifeWorks"].buttons["Hours"].tap()
        
        snapshot("Hours Page")
    }
}
