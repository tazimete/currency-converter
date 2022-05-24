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
    var exchangeBalance = CurrencyExchange(sell: Balance(amount: 200, currency: "EUR"), receive: Balance(amount: 220, currency: "USD"))
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
                            
        let previousToBalance = (balances.first(where: {$0.currency.unwrappedValue.elementsEqual((exchangeBalance.receive?.currency).unwrappedValue)})).unwrappedValue
        let finalFromBalance = (result.first(where: {$0.currency.unwrappedValue.elementsEqual((exchangeBalance.sell?.currency).unwrappedValue)})).unwrappedValue
        let finalToBalance = (result.first(where: {$0.currency.unwrappedValue.elementsEqual((exchangeBalance.receive?.currency).unwrappedValue)})).unwrappedValue
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.count, balances.count)
        XCTAssertTrue(finalFromBalance.amount.unwrappedValue >= 0)
        XCTAssertEqual(finalToBalance.amount.unwrappedValue, previousToBalance.amount.unwrappedValue)
    }
    
    func testBalanceSellWithFailed() {
        exchangeBalance.sell = Balance(amount: 25000, currency: "EUR")
        let result = operation.execute(exchangeBalance: exchangeBalance, balances: balances, commission: commissionCalculator.calculateCommissionAmount(conversionSerial: 15, conversionAmount: (exchangeBalance.sell?.amount).unwrappedValue))
                           
        let previousToBalance = (balances.first(where: {$0.currency.unwrappedValue.elementsEqual((exchangeBalance.receive?.currency).unwrappedValue)})).unwrappedValue
        let finalFromBalance = (result.first(where: {$0.currency.unwrappedValue.elementsEqual((exchangeBalance.sell?.currency).unwrappedValue)})).unwrappedValue
        let finalToBalance = (result.first(where: {$0.currency.unwrappedValue.elementsEqual((exchangeBalance.receive?.currency).unwrappedValue)})).unwrappedValue
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.count, balances.count)
        XCTAssertFalse((finalFromBalance.amount).unwrappedValue >= 0)
        XCTAssertEqual(finalToBalance.amount.unwrappedValue, previousToBalance.amount.unwrappedValue)
    }
}
