//
//  CurencyConvertParameters.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/23/22.
//

import XCTest
@testable import currency_converter

class CurrencyApiRequestTests: XCTestCase {
    var request: CurrencyApiRequest!
    let fromAmount = "100", fromCurrency = "USD", toCurrency = "EUR"

    override func setUp() {
        request = CurrencyApiRequest.convert(params: CurrencyConverterParams(fromAmount: fromAmount, fromCurrency: fromCurrency, toCurrency: toCurrency))
    }
    
    override func tearDown() {
        request = nil
    }
    
    func testUrls() {
        XCTAssertEqual(request.baseURL.absoluteString, "\(AppConfig.shared.getServerConfig().getBaseUrl())")
        XCTAssertEqual(request.baseURL.path, "")
        XCTAssertEqual(request.path, "/currency/commercial/exchange/100-USD/EUR/latest")
    }
    
    func testParameters() {
        XCTAssertEqual((request.parameters[CurrencyConverterParams.CodingKeys.fromAmount.rawValue] as? String).unwrappedValue, fromAmount)
        XCTAssertEqual((request.parameters[CurrencyConverterParams.CodingKeys.fromCurrency.rawValue] as? String).unwrappedValue, fromCurrency)
        XCTAssertEqual((request.parameters[CurrencyConverterParams.CodingKeys.toCurrency.rawValue] as? String).unwrappedValue, toCurrency)
        XCTAssertEqual(request.headers, [String: String]())
    }
    
    func testResponseType() {
        XCTAssertTrue(CurrencyApiRequest.ItemType.self is Currency.Type)
        XCTAssertTrue(CurrencyApiRequest.ResponseType.self is Response<Currency>.Type)
    }
    
    func testMethod() {
        XCTAssertEqual(request.method, RequestType.GET)
        XCTAssertNotEqual(request.method, RequestType.POST)
    }
}
