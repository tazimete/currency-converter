//
//  BalanceOperationExecutorTests.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/24/22.
//

import XCTest
@testable import currency_converter

class BalanceOperationExecutorTests: XCTestCase {
    var operationExecutor: BalanceOperationExecutor!
    var exchangeBalance = CurrencyExchange(sell: Balance(amount: 200, currency: "EUR"), receive: Balance(amount: 220, currency: "USD"))
    var balances = EntityFactory().createList(type: .balance) as! [Balance]
    var commissionCalculator = ComissionCalculator(commissionOptions: ComissionDependency.shared, policies: [FirstFiveConversionComissionPolicy(commissionOptions: ComissionDependency.shared), EveryTenthComissionPolicy(commissionOptions: ComissionDependency.shared), UpToTwoHundredPolicy(commissionOptions: ComissionDependency.shared)])
    
    override func setUp() {
        operationExecutor = BalanceOperationExecutor(operation: BalanceCheckOperation())
    }
    
    override func tearDown() {
        operationExecutor = nil
    }
    
    func testDependencies() {
        XCTAssertNotNil(operationExecutor)
    }
    
    func test_executeBalance_checkOperation_withTrue() {
        let result = operationExecutor.executeCheck(exchangeBalance: exchangeBalance, balances: balances, commission: commissionCalculator.calculateCommissionAmount(conversionSerial: 15, conversionAmount: (exchangeBalance.sell?.amount).unwrappedValue))
                                     
        XCTAssertNotNil(result)
        XCTAssertEqual(result, true)
    }
    
    func test_executeBalance_checkOperation_withFalse() {
        exchangeBalance.sell = Balance(amount: 12000, currency: "EUR")
        let result = operationExecutor.executeCheck(exchangeBalance: exchangeBalance, balances: balances, commission: commissionCalculator.calculateCommissionAmount(conversionSerial: 15, conversionAmount: (exchangeBalance.sell?.amount).unwrappedValue))
                                     
        XCTAssertNotNil(result)
        XCTAssertEqual(result, false)
    }
}
