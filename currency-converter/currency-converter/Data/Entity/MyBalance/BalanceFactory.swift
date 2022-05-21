//
//  BalanceFactory.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/21/22.
//

import Foundation


class ModelFactory {
    enum ModelType{
        case balance
        case currencyExchange
    }
    
    func createList(type: ModelType) -> [AbstractDataModel] {
        var result = [AbstractDataModel] ()
        
        if type == .balance {
            result =  [Balance(amount: 1000.00, currency: "USD"), Balance(amount: 100, currency: "EUR"), Balance(amount: 100, currency: "JPY"), Balance(amount: 100, currency: "BDT")]
        }
        
        return result
    }
}
