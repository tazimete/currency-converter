//
//  BalanceCheckOpration.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/21/22.
//

import Foundation


struct BalanceCheckOperation: BalanceOperation {
    func check(exchangeBalance: CurrencyExchange, balances: [Balance], commission: Double) -> Bool {
        var result = true
        let currency = exchangeBalance.sell?.currency ?? ""
        let amount = exchangeBalance.sell?.amount ?? 0.00
        
        //check in all available balances
        if let index = balances.firstIndex(where: { $0.currency?.elementsEqual(currency) ?? false}) {
            let diff = (balances[index].amount ?? 0.0) - amount - commission
            result = diff >= 0 ? true : false
        }
        
        return result
    }
}


