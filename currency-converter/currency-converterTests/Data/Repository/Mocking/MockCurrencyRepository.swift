//
//  MockCurrencyRepository.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/23/22.
//

import Foundation
@testable import currency_converter
import RxSwift

class MockCurrencyRepository: AbstractCurrencyRepository {
    let localDataSource: AbstractLocalDataSource
    let remoteDataSource: AbstractRemoteDataSource
    
    init(localDataSource: AbstractLocalDataSource, remoteDataSource: AbstractRemoteDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func get(fromAmount: String, fromCurrency: String, toCurrency: String) -> Observable<CurrencyApiRequest.ItemType> {
        return (remoteDataSource as! AbstractCurrencyRemoteDataSource).get(fromAmount: fromAmount, fromCurrency: fromCurrency, toCurrency: toCurrency)
    }
}

