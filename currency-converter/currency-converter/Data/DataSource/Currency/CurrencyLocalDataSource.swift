//
//  CurrencyLocalDataSource.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/14/22.
//

import Foundation
import RxSwift


class CurrencyLocalDataSource: AbstractCurrencyLocalDataSource {
    let dbClient: AbstractDatabaseClient
    
    init(dbClient: AbstractDatabaseClient) {
        self.dbClient = dbClient
    }
    
    func get(amount: String, currency: String) -> Observable<CurrencyApiRequest.ItemType> {
        return dbClient.read(id: currency, type: CurrencyApiRequest.ItemType.self)
    }
}
