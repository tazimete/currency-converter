//
//  CurrencyRepositoryTests.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/23/22.
//

import XCTest
@testable import currency_converter

class CurrencyRepositoryTests: XCTestCase {
    private var currencyRepository: AbstractCurrencyRepository!

    override func setUp() {
        currencyRepository = CurrencyRepository(localDataSource: MockLocalCurrencyDataSource(dbClient: MockLocalStorageInteractor.shared), remoteDataSource: MockRemoteCurrencyDataSource(apiClient: MockAPIClient.shared))
    }
    
    override func tearDown() {
        currencyRepository = nil
    }

}
