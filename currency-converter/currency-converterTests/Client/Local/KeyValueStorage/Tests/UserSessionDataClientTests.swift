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
    
    func testConversionCount() {
        userSessionDataClient.setConversionCount(count: 10)
        
        XCTAssertEqual(userSessionDataClient.getConversionCount(), 10)
    }
}

