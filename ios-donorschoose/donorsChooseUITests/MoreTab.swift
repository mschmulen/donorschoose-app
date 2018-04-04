//
//  MoreTab.swift
//  donorsChooseUITests
//
//  Created by Matt Schmulen on 4/4/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import XCTest

func moreTab(_ app: XCUIApplication) {
    
    let tabButtonText = "More"
    
    XCTAssertTrue(app.buttons[tabButtonText].waitForExistence(timeout: defaultExistanceTimeout ))
//    XCTAssertTrue(app.tabBars.buttons[tabName].waitForExistence(timeout: defaultExistanceTimeout ))
//    let tabButton = app.buttons["\(tabButtonText)TabButton"]
    
    let tabButton = app.buttons[tabButtonText]
    tabButton.tap()
    
    print( "tap")
    
    //verify expected rows
}

