//
//  BalanceCheckOperationsTests.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/24/22.
//

import XCTest
@testable import currency_converter

class BalanceCheckOperationsTests: XCTestCase {
    var operation: BalanceCheckOperation!
    var exchangeBalance = CurrencyExchange(sell: Balance(amount: 200, currency: "EUR"), receive: nil)
    var balances = MockEntityFactory().createList(type: .balance) as! [Balance]
    var commissionCalculator = ComissionCalculator(commissionOptions: ComissionDependency.shared, policies: [FirstFiveConversionComissionPolicy(commissionOptions: ComissionDependency.shared), EveryTenthComissionPolicy(commissionOptions: ComissionDependency.shared), UpToTwoHundredPolicy(commissionOptions: ComissionDependency.shared)])

    override func setUp() {
        operation = BalanceCheckOperation()
    }
    
    override func tearDown() {
        operation = nil
    }
    
    func testDependencies() {
        XCTAssertNotNil(operation)
    }
    
    func testCheckBalanceWithTrue() {
        let result = operation.check(exchangeBalance: exchangeBalance, balances: balances, commission: commissionCalculator.calculateCommissionAmount(conversionSerial: 15, conversionAmount: (exchangeBalance.sell?.amount).unwrappedValue))
                                     
        XCTAssertNotNil(result)
        XCTAssertEqual(result, true) 
    }
    
    func testCheckBalanceWithFalse() {
        exchangeBalance.sell = Balance(amount: 12000, currency: "EUR")
        let result = operation.check(exchangeBalance: exchangeBalance, balances: balances, commission: commissionCalculator.calculateCommissionAmount(conversionSerial: 15, conversionAmount: (exchangeBalance.sell?.amount).unwrappedValue))
                                     
        XCTAssertNotNil(result)
        XCTAssertEqual(result, false)
    }
}
