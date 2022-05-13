//
//  CurrencyRemoteDataSource.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/14/22.
//

import Foundation
import RxSwift


class CurrencyRemoteDataSource: AbstractCurrencyRemoteDataSource {
    let apiClient: AbstractApiClient
    
    init(apiClient: AbstractApiClient) {
        self.apiClient = apiClient
    }
    
    func get(amount: String, currency: String) -> Observable<CurrencyApiRequest.ItemType> {
        return apiClient.send(apiRequest: CurrencyApiRequest.convert(params: CurrencyConverterParams(amount: amount, currency: currency)), type: CurrencyApiRequest.ItemType.self)
    }
}
