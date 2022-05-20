//
//  BalanceReceiveOperation.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/21/22.
//

import Foundation


struct BalanceReceiveOperation: BalanceOperation {
    func execute(exchangeBalance: CurrencyExchange, balances: [Balance], commission: Double) -> [Balance] {
        var balances = balances
        let receiveCurrency = exchangeBalance.receive?.currency ?? ""
        let receiveAmount = exchangeBalance.receive?.amount ?? 0.00
        
        // set recieve amount
        if let index = balances.firstIndex(where: { $0.currency?.elementsEqual(receiveCurrency) ?? false}) {
            balances[index].amount = (balances[index].amount ?? 0.0) + receiveAmount
        }
        
        return balances
    }
}
