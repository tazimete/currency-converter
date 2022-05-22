//
//  MockLocalCurrencyDataSource.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/23/22.
//

import Foundation
@testable import currency_converter
import RxSwift

class MockLocalCurrencyDataSource: AbstractCurrencyLocalDataSource {
    let dbClient: AbstractDatabaseClient
    
    init(dbClient: AbstractDatabaseClient) {
        self.dbClient = dbClient
    }
    
    func get(fromAmount: String, fromCurrency: String, toCurrency: String) -> Observable<CurrencyApiRequest.ItemType> {
        return dbClient.read(id: fromAmount, type: CurrencyApiRequest.ItemType.self)
    }
}
