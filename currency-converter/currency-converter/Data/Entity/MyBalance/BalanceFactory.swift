//
//  BalanceFactory.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/21/22.
//

import Foundation


enum EntityType {
    case balance
}

class EntityFactory {
    enum EntityType {
        case balance
        case currencyExchange
    }
    
    func create(type: EntityType) -> [AbstractDataModel] {
        if type == .balance {
            return [Balance(amount: 1000.00, currency: "USD"), Balance(amount: 100, currency: "EUR"), Balance(amount: 100, currency: "JPY"), Balance(amount: 100, currency: "BDT")]
        } else {
            return [] 
        }
    }
}
