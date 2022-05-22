//
//  KVLocalStorageTests.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/23/22.
//

import XCTest
@testable import currency_converter
import RxSwift


class UserSessionDataClientTests: XCTestCase {

    private var userSessionDataClient: UserSessionDataClient!
    
    override func setUp() {
        userSessionDataClient = UserSessionDataClient.shared as! UserSessionDataClient
        userSessionDataClient.kvContainer = MockLocalStorageInteractor()
    }
    
    override func tearDown() {
        userSessionDataClient = nil
    }
    
    func testKVContainer() {
        XCTAssertNotNil(userSessionDataClient.kvContainer)
    }
    
    func testSetConversionCount() {
        userSessionDataClient.setConversionCount(count: 10)
        let value = userSessionDataClient.conversionCount
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 10)
        XCTAssertNotEqual(value, 20)
    }
    
    func testGetConversionCount() {
        userSessionDataClient.setConversionCount(count: 20)
        let value = userSessionDataClient.getConversionCount()
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 20)
        XCTAssertNotEqual(value, 10)
    }
}

