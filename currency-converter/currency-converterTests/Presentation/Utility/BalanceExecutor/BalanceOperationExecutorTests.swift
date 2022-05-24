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
    
    func test_executeBalance_sellOperation_withSucess() {
        operationExecutor.update(operation: BalanceSellOperation())
        
        let result = operationExecutor.executeBalance(exchangeBalance: exchangeBalance, balances: balances, commission: commissionCalculator.calculateCommissionAmount(conversionSerial: 15, conversionAmount: (exchangeBalance.sell?.amount).unwrappedValue))
                            
        let sellBalance = exchangeBalance.sell ?? Balance()
        let receiveBalance = exchangeBalance.receive ?? Balance()
        
        let previousToBalance = (balances.first(where: {$0.currency.unwrappedValue.elementsEqual(receiveBalance.currency.unwrappedValue)})).unwrappedValue
        let finalFromBalance = (result.first(where: {$0.currency.unwrappedValue.elementsEqual(sellBalance.currency.unwrappedValue)})).unwrappedValue
        let finalToBalance = (result.first(where: {$0.currency.unwrappedValue.elementsEqual(receiveBalance.currency.unwrappedValue)})).unwrappedValue
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.count, balances.count)
        XCTAssertTrue(finalFromBalance.amount.unwrappedValue >= 0)
        XCTAssertEqual(finalToBalance.amount.unwrappedValue, previousToBalance.amount.unwrappedValue)
    }
    
    func test_executeBalance_sellOperation_withFailed() {
        operationExecutor.update(operation: BalanceSellOperation())
        exchangeBalance.sell = Balance(amount: 25000, currency: "EUR")
        
        let result = operationExecutor.executeBalance(exchangeBalance: exchangeBalance, balances: balances, commission: commissionCalculator.calculateCommissionAmount(conversionSerial: 15, conversionAmount: (exchangeBalance.sell?.amount).unwrappedValue))
                           
        let sellBalance = exchangeBalance.sell ?? Balance()
        let receiveBalance = exchangeBalance.receive ?? Balance()
        
        let previousToBalance = (balances.first(where: {$0.currency.unwrappedValue.elementsEqual(receiveBalance.currency.unwrappedValue)})).unwrappedValue
        let finalFromBalance = (result.first(where: {$0.currency.unwrappedValue.elementsEqual(sellBalance.currency.unwrappedValue)})).unwrappedValue
        let finalToBalance = (result.first(where: {$0.currency.unwrappedValue.elementsEqual(receiveBalance.currency.unwrappedValue)})).unwrappedValue
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.count, balances.count)
        XCTAssertFalse((finalFromBalance.amount).unwrappedValue >= 0)
        XCTAssertEqual(finalToBalance.amount.unwrappedValue, previousToBalance.amount.unwrappedValue)
    }
    
    func test_executeBalance_receiveOperation_withSuccess() {
        operationExecutor.update(operation: BalanceReceiveOperation())
        
        let result = operationExecutor.executeBalance(exchangeBalance: exchangeBalance, balances: balances, commission: commissionCalculator.calculateCommissionAmount(conversionSerial: 15, conversionAmount: (exchangeBalance.sell?.amount).unwrappedValue))
                            
        let receiveBalance = exchangeBalance.receive ?? Balance()
        
        let previousToBalance = (balances.first(where: {$0.currency.unwrappedValue.elementsEqual(receiveBalance.currency.unwrappedValue)})).unwrappedValue
        let finalToBalance = (result.first(where: {$0.currency.unwrappedValue.elementsEqual(receiveBalance.currency.unwrappedValue)})).unwrappedValue
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.count, balances.count)
        XCTAssertNotEqual(finalToBalance.amount.unwrappedValue, previousToBalance.amount.unwrappedValue)
        XCTAssertEqual(finalToBalance.amount.unwrappedValue, previousToBalance.amount.unwrappedValue + receiveBalance.amount.unwrappedValue)
    }
    
    func test_executeBalance_receiveOperation_withFailed() {
        operationExecutor.update(operation: BalanceReceiveOperation())
        
        let result = operationExecutor.executeBalance(exchangeBalance: exchangeBalance, balances: balances, commission: commissionCalculator.calculateCommissionAmount(conversionSerial: 15, conversionAmount: (exchangeBalance.sell?.amount).unwrappedValue))
                        
        let receiveBalance = exchangeBalance.receive ?? Balance()
        
        let previousToBalance = (balances.first(where: {$0.currency.unwrappedValue.elementsEqual(receiveBalance.currency.unwrappedValue)})).unwrappedValue
        let finalToBalance = (result.first(where: {$0.currency.unwrappedValue.elementsEqual(receiveBalance.currency.unwrappedValue)})).unwrappedValue
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.count, balances.count)
        XCTAssertNotEqual(finalToBalance.amount.unwrappedValue, previousToBalance.amount.unwrappedValue)
        XCTAssertEqual(finalToBalance.amount.unwrappedValue, previousToBalance.amount.unwrappedValue + receiveBalance.amount.unwrappedValue)
    }
}
