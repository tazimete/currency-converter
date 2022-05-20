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
