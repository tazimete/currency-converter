//
//  BalanceFactory.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/21/22.
//

import Foundation


class BalanceFactory {
    enum BalanceType{
        case balance
        case currencyExchange
    }
    
    func createList(type: BalanceType) -> [AbstractDataModel] {
        if type == .balance {
            return [Balance(amount: 1000.00, currency: "USD"), Balance(amount: 100, currency: "EUR"), Balance(amount: 100, currency: "JPY"), Balance(amount: 100, currency: "BDT")]
        } else {
            return [] 
        }
    }
}
