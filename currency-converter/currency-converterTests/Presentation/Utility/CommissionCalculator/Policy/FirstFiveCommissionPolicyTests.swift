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
    
    func testHasCommissionWithTrue() {
        let result = commissionPolicy.hasComission(conversionSerial: 35, conversionAmount: 250)
        
        XCTAssertTrue(result)
    }
    
    func testHasCommissionWithFalse() {
        let result = commissionPolicy.hasComission(conversionSerial: 3, conversionAmount: 250)
        
        XCTAssertFalse(result)
    }
    
    func testGetComissionAmountWithZero() {
        let result = commissionPolicy.getComissionAmount(conversionSerial: 3, conversionAmount: 250)
        
        XCTAssertEqual(result, 0.00)
    }
    
    func testGetComissionAmountWithGreaterThanZero() {
        let result = commissionPolicy.getComissionAmount(conversionSerial: 35, conversionAmount: 250)
        
        XCTAssertEqual(result, 1.75)
    }
    
    func testGetComissionPercentageWithZero() {
        let result = commissionPolicy.getComissionPercent(conversionSerial: 3, conversionAmount: 250)
        
        XCTAssertEqual(result, 0.00)
        XCTAssertNotEqual(result, commissionPolicy.commissionOptions.comissionAmountInPercent)
    }
    
    func testGetComissionPercentageGreaterThanZero() {
        let result = commissionPolicy.getComissionPercent(conversionSerial: 35, conversionAmount: 250)
        
        XCTAssertEqual(result, commissionPolicy.commissionOptions.comissionAmountInPercent)
        XCTAssertNotEqual(result, 0.00)
    }
}
