//
//  BalanceTests.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/25/22.
//

import XCTest
@testable import currency_converter

class BalanceTests: XCTestCase {
    private var balance: Balance!

    override func setUp() {
        balance = Balance(amount: 200, currency: "EUR")
    }
    
    override func tearDown() {
        balance = nil
    }
    
    func testAmount() {
        XCTAssertEqual(balance.amount.unwrappedValue, 200)
    }
    
    func testCurrency() {
        XCTAssertEqual(balance.currency.unwrappedValue, "EUR")
    }
    
    func testAsDictionary() {
        let dictionary = balance.asDictionary
        XCTAssertEqual((dictionary?[Balance.CodingKeys.amount.rawValue] as? Double).unwrappedValue, 200)
        XCTAssertEqual((dictionary?[Balance.CodingKeys.currency.rawValue] as? String).unwrappedValue, "EUR")
    }
    
    func testAsCellViewModel() {
        let viewmodel = balance.asCellViewModel
        XCTAssertEqual(viewmodel.title.unwrappedValue, "\(balance.amount.unwrappedValue) \(balance.currency.unwrappedValue)")
    }
}
