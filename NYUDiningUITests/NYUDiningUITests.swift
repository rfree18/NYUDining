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
        
        let app = XCUIApplication()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Palladium by LifeWorks"]/*[[".cells.staticTexts[\"Palladium by LifeWorks\"]",".staticTexts[\"Palladium by LifeWorks\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Menu"].tap()
        app.webViews.children(matching: .other).element.children(matching: .other).element.tap()
        app.navigationBars["Menu"].buttons["Palladium by LifeWorks"]/*@START_MENU_TOKEN@*/.press(forDuration: 0.8);/*[[".tap()",".press(forDuration: 0.8);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        app.navigationBars["Palladium by LifeWorks"].buttons["Hours"].tap()

    }
}
