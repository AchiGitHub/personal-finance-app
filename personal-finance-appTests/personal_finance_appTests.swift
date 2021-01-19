//
//  personal_finance_appTests.swift
//  personal-finance-appTests
//
//  Created by Achintha Ikiriwatte on 2020-12-23.
//

import XCTest
@testable import personal_finance_app

class personal_finance_appTests: XCTestCase {

    func testAddAccounts()
    {
        let income = NewIncomeViewController()
        let result = income.save(title: "test", date: Date(), note: "note", amount: 10000.00, accountName: "cash",updateAC: false)
        XCTAssertTrue(result)
    }
    
    func testAddDebt()
    {
        let budget = AddDebtViewController()
        let result = budget.save("Mr.X", 2000.00, "sample description", Date())
        XCTAssertTrue(result)
    }
    
    
}
