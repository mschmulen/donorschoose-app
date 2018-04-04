//
//  FavoriteTab.swift
//  donorsChooseUITests
//
//  Created by Matt Schmulen on 4/4/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import XCTest

func favoritesTab(_ app: XCUIApplication) {
    
    let tabButtonText = "Favorites"
    
    XCTAssertTrue(app.buttons[tabButtonText].waitForExistence(timeout: defaultExistanceTimeout ))
    
    let tabButton = app.buttons[tabButtonText]
    tabButton.tap()
    
    print( "tap")
}

