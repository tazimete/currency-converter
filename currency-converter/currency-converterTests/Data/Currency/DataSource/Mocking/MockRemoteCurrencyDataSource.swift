//
//  MockRemoteCurrencyDataSource.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/23/22.
//

import Foundation
@testable import currency_converter
import RxSwift

class MockRemoteCurrencyDataSource: AbstractCurrencyRemoteDataSource {
    let apiClient: AbstractApiClient
    
    init(apiClient: AbstractApiClient) {
        self.apiClient = apiClient
    }
    
    func get(fromAmount: String, fromCurrency: String, toCurrency: String) -> Observable<CurrencyApiRequest.ItemType> {
        return apiClient.send(apiRequest: CurrencyApiRequest.convert(params: CurrencyConverterParams(fromAmount: fromAmount, fromCurrency: fromCurrency, toCurrency: toCurrency)), type: CurrencyApiRequest.ItemType.self)
    }
}

