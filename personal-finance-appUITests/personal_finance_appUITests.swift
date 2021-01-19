//
//  personal_finance_appUITests.swift
//  personal-finance-appUITests
//
//  Created by Achintha Ikiriwatte on 2020-12-23.
//

import XCTest

class personal_finance_appUITests: XCTestCase {

   
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        /*
        let AccountName =  app.textFields["AcAddName"]
        AccountName.tap()
        AccountName.typeText("Hello new AC")
         */
        
        let totalBalance =  app.staticTexts["TotalBalanceLabel"]
        XCTAssertEqual("Rs. 555.0", totalBalance.label)
        
    }

  
}
