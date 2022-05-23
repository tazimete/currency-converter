//
//  CurrencyConvertParametersTests.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/23/22.
//

import XCTest
@testable import currency_converter

class CurrencyConvertParametersTests: XCTestCase {
    var params: CurrencyConverterParams!
    let fromAmount = "100", fromCurrency = "USD", toCurrency = "EUR"

    override func setUp() {
        params = CurrencyConverterParams(fromAmount: fromAmount, fromCurrency: fromCurrency, toCurrency: toCurrency)
    }
    
    override func tearDown() {
        params = nil
    }
    
    func testDependencies() {
        XCTAssertNotNil(params)
        XCTAssertNotNil(params.fromAmount)
        XCTAssertNotNil(params.fromCurrency)
        XCTAssertNotNil(params.toCurrency)
    }
    
    func testParamsters() {
        XCTAssertEqual(params.fromAmount, fromAmount)
        XCTAssertEqual(params.fromCurrency, fromCurrency)
        XCTAssertEqual(params.toCurrency, toCurrency)
    }
}
