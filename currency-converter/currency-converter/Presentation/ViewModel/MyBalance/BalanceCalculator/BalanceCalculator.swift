//
//  BalanceCalculator.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/20/22.
//

import Foundation

struct BalanceCalculator {
    // check enough balance before exchange
    func hasEnoughBalance(exchangeBalance: CurrencyExchange, balances: [Balance], commission: Double) -> Bool {
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
    
    // deduct and increase balance after exchange
    func calculatFinalBalance(exchangeBalance: CurrencyExchange, balances: [Balance]) -> [Balance] {
        var balances = balances
        let sellCurrency = exchangeBalance.sell?.currency ?? ""
        let receiveCurrency = exchangeBalance.receive?.currency ?? ""
        let sellAmount = exchangeBalance.sell?.amount ?? 0.00
        let receiveAmount = exchangeBalance.receive?.amount ?? 0.00
        
        // set recieve amount
        if let index = balances.firstIndex(where: { $0.currency?.elementsEqual(receiveCurrency) ?? false}) {
            balances[index].amount = (balances[index].amount ?? 0.0) + receiveAmount
        }
        
        //set deduct amount from sell balance
        if let index = balances.firstIndex(where: { $0.currency?.elementsEqual(sellCurrency) ?? false}) {
            balances[index].amount = (balances[index].amount ?? 0.0) - sellAmount
        }
        
        return balances
    }
}
