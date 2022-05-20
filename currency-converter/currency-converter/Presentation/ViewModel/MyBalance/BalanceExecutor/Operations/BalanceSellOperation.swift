//
//  BalanceSellOperation.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/21/22.
//

import Foundation


struct BalanceSellOperation: BalanceOperation {
    func execute(exchangeBalance: CurrencyExchange, balances: [Balance], commission: Double) -> [Balance] {
        var balances = balances
        let sellCurrency = exchangeBalance.sell?.currency ?? ""
        let sellAmount = exchangeBalance.sell?.amount ?? 0.00
        
        //set deduct amount from sell balance
        if let index = balances.firstIndex(where: { $0.currency?.elementsEqual(sellCurrency) ?? false}) {
            balances[index].amount = (balances[index].amount ?? 0.0) - sellAmount - commission
        }
        
        return balances
    }
}
