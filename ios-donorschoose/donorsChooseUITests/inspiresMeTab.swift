//
//  InspiresMeTab.swift
//  donorsChooseUITests
//
//  Created by Matt Schmulen on 4/4/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import XCTest

func inspriesMeTab(_ app: XCUIApplication) {

  let tabButtonText = "Inspires Me"

  XCTAssertTrue(app.buttons[tabButtonText].waitForExistence(timeout: defaultExistanceTimeout ))

  let tabButton = app.buttons[tabButtonText]
  tabButton.tap()

  print( "tap")

//  let tablesQuery = app.tables
//
//  //  tablesQuery.staticTexts["Donors Choose App"].tap()
//  tablesQuery.staticTexts["About This App"].tap()
//
//  _ = app.navigationBars.buttons.element(boundBy: 0).waitForExistence(timeout: defaultExistanceTimeout)
//  app.navigationBars.buttons.element(boundBy: 0).tap()
//
//  tablesQuery.staticTexts["Search Tools"].tap()
//  _ = app.navigationBars.buttons.element(boundBy: 0).waitForExistence(timeout: defaultExistanceTimeout)
//  app.navigationBars.buttons.element(boundBy: 0).tap()

}


