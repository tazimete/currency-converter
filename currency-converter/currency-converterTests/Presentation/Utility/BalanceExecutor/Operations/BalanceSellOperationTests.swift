//
//  BalanceSellOperationTests.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/24/22.
//

import XCTest
@testable import currency_converter

class BalanceSellOperationTests: XCTestCase {
    var operation: BalanceSellOperation!
    var exchangeBalance = CurrencyExchange(sell: Balance(amount: 200, currency: "EUR"), receive: Balance(amount: nil, currency: "USD"))
    var balances = EntityFactory().createList(type: .balance) as! [Balance]
    var commissionCalculator = ComissionCalculator(commissionOptions: ComissionDependency.shared, policies: [FirstFiveConversionComissionPolicy(commissionOptions: ComissionDependency.shared), EveryTenthComissionPolicy(commissionOptions: ComissionDependency.shared), UpToTwoHundredPolicy(commissionOptions: ComissionDependency.shared)])

    override func setUp() {
        operation = BalanceSellOperation()
    }
    
    override func tearDown() {
        operation = nil
    }
    
    func testDependencies() {
        XCTAssertNotNil(operation)
    }
    
    func testBalanceSellWithSucess() {
        let result = operation.execute(exchangeBalance: exchangeBalance, balances: balances, commission: commissionCalculator.calculateCommissionAmount(conversionSerial: 15, conversionAmount: (exchangeBalance.sell?.amount).unwrappedValue))
                                     
        XCTAssertNotNil(result)
        XCTAssertEqual(result.count, 3)
    }
    
    func testBalanceSellWithFailed() {
        
    }
}
