//
//  CommissionCalculatorTests.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/25/22.
//

import XCTest
@testable import currency_converter

class CommissionCalculatorTests: XCTestCase {
    private var commissionCalculator: ComissionCalculator!
    
    override func setUp() {
        commissionCalculator = ComissionCalculator(commissionOptions: ComissionDependency.shared, policies: [FirstFiveConversionComissionPolicy(commissionOptions: ComissionDependency.shared), EveryTenthComissionPolicy(commissionOptions: ComissionDependency.shared), UpToTwoHundredPolicy(commissionOptions: ComissionDependency.shared)])
    }
    
    override func tearDown() {
        commissionCalculator = nil
    }
    
    func testDependencies() {
        XCTAssertNotNil(commissionCalculator.commissionOptions)
        XCTAssertNotNil(commissionCalculator.policies)
        XCTAssertEqual(commissionCalculator.policies.count, 3)
    }
    
    func test_hasCommission_withTrue() {
        let result = commissionCalculator.hasCommission(conversionSerial: 35, conversionAmount: 250)
        
        XCTAssertTrue(result.hasCommission)
    }
    
    func test_hasCommission_withFalse() {
        let result = commissionCalculator.hasCommission(conversionSerial: 3, conversionAmount: 250)
        
        XCTAssertFalse(result.hasCommission)
    }
    
    func test_calculateCommissionAmount_withSerial_3() {
        let result = commissionCalculator.calculateCommissionAmount(conversionSerial: 3, conversionAmount: 250)
        
        XCTAssertEqual(result, 0.00)
    }
    
    func test_calculateCommissionAmount_withSerial_15() {
        let result = commissionCalculator.calculateCommissionAmount(conversionSerial: 15, conversionAmount: 250)
        
        XCTAssertEqual(result, 1.75)
    }
    
    func test_calculateCommissionPercent_withSerial_3() {
        let result = commissionCalculator.calculateCommissionPercent(conversionSerial: 3, conversionAmount: 250)
        
        XCTAssertEqual(result, 0.00)
        XCTAssertNotEqual(result, commissionCalculator.commissionOptions.comissionAmountInPercent)
    }
    
    func test_calculateCommissionPercent_withSerial_15() {
        let result = commissionCalculator.calculateCommissionPercent(conversionSerial: 15, conversionAmount: 250)
        
        XCTAssertEqual(result, commissionCalculator.commissionOptions.comissionAmountInPercent)
        XCTAssertNotEqual(result, 0.00)
    }
}
