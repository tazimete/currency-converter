//
//  BalanceReceiveOperationTests.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/24/22.
//

import XCTest
@testable import currency_converter

class BalanceReceiveOperationTests: XCTestCase {
    var operation: BalanceReceiveOperation!
    var exchangeBalance = CurrencyExchange(sell: Balance(amount: 200, currency: "EUR"), receive: Balance(amount: 220, currency: "USD"))
    var balances = MockEntityFactory().createList(type: .balance) as! [Balance]
    var commissionCalculator = ComissionCalculator(commissionOptions: ComissionDependency.shared, policies: [FirstFiveConversionComissionPolicy(commissionOptions: ComissionDependency.shared), EveryTenthComissionPolicy(commissionOptions: ComissionDependency.shared), UpToTwoHundredPolicy(commissionOptions: ComissionDependency.shared)])

    override func setUp() {
        operation = BalanceReceiveOperation()
    }
    
    override func tearDown() {
        operation = nil
    }
    
    func testDependencies() {
        XCTAssertNotNil(operation)
    }
    
    func testBalanceReceiveWithSucess() {
        let result = operation.execute(exchangeBalance: exchangeBalance, balances: balances, commission: commissionCalculator.calculateCommissionAmount(conversionSerial: 15, conversionAmount: (exchangeBalance.sell?.amount).unwrappedValue))
                            
        let receiveBalance = exchangeBalance.receive ?? Balance()
        
        let previousToBalance = (balances.first(where: {$0.currency.unwrappedValue.elementsEqual(receiveBalance.currency.unwrappedValue)})).unwrappedValue
        let finalToBalance = (result.first(where: {$0.currency.unwrappedValue.elementsEqual(receiveBalance.currency.unwrappedValue)})).unwrappedValue
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.count, balances.count)
        XCTAssertNotEqual(finalToBalance.amount.unwrappedValue, previousToBalance.amount.unwrappedValue)
        XCTAssertEqual(finalToBalance.amount.unwrappedValue, previousToBalance.amount.unwrappedValue + receiveBalance.amount.unwrappedValue)
    }
    
    func testBalanceReceiveWithFailed() {
        let result = operation.execute(exchangeBalance: exchangeBalance, balances: balances, commission: commissionCalculator.calculateCommissionAmount(conversionSerial: 15, conversionAmount: (exchangeBalance.sell?.amount).unwrappedValue))
                        
        let receiveBalance = exchangeBalance.receive ?? Balance()
        
        let previousToBalance = (balances.first(where: {$0.currency.unwrappedValue.elementsEqual(receiveBalance.currency.unwrappedValue)})).unwrappedValue
        let finalToBalance = (result.first(where: {$0.currency.unwrappedValue.elementsEqual(receiveBalance.currency.unwrappedValue)})).unwrappedValue
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.count, balances.count)
        XCTAssertNotEqual(finalToBalance.amount.unwrappedValue, previousToBalance.amount.unwrappedValue)
        XCTAssertEqual(finalToBalance.amount.unwrappedValue, previousToBalance.amount.unwrappedValue + receiveBalance.amount.unwrappedValue)
    }
}
