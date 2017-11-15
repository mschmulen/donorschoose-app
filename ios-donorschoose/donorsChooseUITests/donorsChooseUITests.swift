//
//  donorsChooseUITests.swift

import XCTest

class donorsChooseUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//        XCUIApplication().launch()
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testScreenshots() {
        
        snapshot("0Launch")
        let tabBarsQuery = XCUIApplication().tabBars
        
        tabBarsQuery.buttons["In Need"].tap()
        snapshot("1InNeed")
        
        tabBarsQuery.buttons["Near Me"].tap()
        snapshot("2NearMe")
        
        tabBarsQuery.buttons["Inspires Me"].tap()
        snapshot("3InspiresMe")

        tabBarsQuery.buttons["Favorites"].tap()
        snapshot("4Favorites")

        tabBarsQuery.buttons["About"].tap()
        snapshot("5About")
        
        tabBarsQuery.buttons["In Need"].tap()
    }
    
}
