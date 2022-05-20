//
//  BalanceCalculatable.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/21/22.
//

import Foundation


protocol BalanceOperation {
    func check(exchangeBalance: CurrencyExchange, balances: [Balance], commission: Double) -> Bool
    func execute(exchangeBalance: CurrencyExchange, balances: [Balance], commission: Double) -> [Balance]
}

extension BalanceOperation {
    func check(exchangeBalance: CurrencyExchange, balances: [Balance], commission: Double) -> Bool {
        return true
    }
    
    func execute(exchangeBalance: CurrencyExchange, balances: [Balance], commission: Double) -> [Balance] {
        return []
    }
}

