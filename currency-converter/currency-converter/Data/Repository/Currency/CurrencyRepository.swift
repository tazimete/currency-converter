//
//  CurrencyRepository.swift
//  currency-converter
//
//  Created by AGM Tazim on 30/10/21.
//

import Foundation
import RxSwift

/* This is Currency repository class implementation from AbstractCurrencyRepository. Which will be used to get currency related data from api client/server response*/
class CurrencyRepository<T>: AbstractCurrencyRepository {
    let localDataSource: AbstractLocalDataSource
    let remoteDataSource: AbstractRemoteDataSource
    
    init(localDataSource: AbstractLocalDataSource, remoteDataSource: AbstractRemoteDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func convert(amount: String, currency: String) -> Observable<CurrencyApiRequest.ItemType> {
//        return apiClient.send(apiRequest: CurrencyApiRequest.convert(params: CurrencyConverterParams(amount: amount, currency: currency)), type: CurrencyApiRequest.ItemType.self)
    }
}
