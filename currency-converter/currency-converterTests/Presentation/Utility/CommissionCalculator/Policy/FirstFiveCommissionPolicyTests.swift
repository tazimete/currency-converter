//
//  FirstFiveCommissionPolicyTests.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/25/22.
//

import XCTest
@testable import currency_converter

class FirstFiveCommissionPolicyTests: XCTestCase {
    var commissionPolicy: FirstFiveConversionComissionPolicy!
    
    override func setUp() {
        commissionPolicy = FirstFiveConversionComissionPolicy(commissionOptions: ComissionDependency.shared)
    }
    
    override func tearDown() {
        commissionPolicy = nil
    }
    
    func testDependencies() {
        XCTAssertNotNil(commissionPolicy)
        XCTAssertNotNil(commissionPolicy.commissionOptions)
    }
    
    func test_hasCommission_withTrue() {
        let result = commissionPolicy.hasComission(conversionSerial: 35, conversionAmount: 250)
        
        XCTAssertTrue(result)
    }
    
    func test_hasCommission_withFalse() {
        let result = commissionPolicy.hasComission(conversionSerial: 3, conversionAmount: 250)
        
        XCTAssertFalse(result)
    }
    
    func test_getComissionAmount_withSerial_3() {
        let result = commissionPolicy.getComissionAmount(conversionSerial: 3, conversionAmount: 250)
        
        XCTAssertEqual(result, 0.00)
    }
    
    func test_getComissionAmount_withSerial_10() {
        let result = commissionPolicy.getComissionAmount(conversionSerial: 10, conversionAmount: 250)
        
        XCTAssertEqual(result, 1.75)
    }
    
    func test_getComissionPercentage_withSerial_3() {
        let result = commissionPolicy.getComissionPercent(conversionSerial: 3, conversionAmount: 250)
        
        XCTAssertEqual(result, 0.00)
        XCTAssertNotEqual(result, commissionPolicy.commissionOptions.comissionAmountInPercent)
    }
    
    func test_getComissionPercentage_withSerial_10() {
        let result = commissionPolicy.getComissionPercent(conversionSerial: 10, conversionAmount: 250)
        
        XCTAssertEqual(result, commissionPolicy.commissionOptions.comissionAmountInPercent)
        XCTAssertNotEqual(result, 0.00)
    }
}
