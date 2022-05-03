//
//  GithubUserParams.swift
//  currency-converter
//
//  Created by AGM Tazimon 24/7/21.
//

import Foundation


struct CurrencyConverterParams: Parameterizable{
    let apiKey: String = AppConfig.shared.getServerConfig().setAuthCredential().apiKey ?? ""
    let amount: String
    let currency: String 

    public init(amount: String, currency: String) {
        self.amount = amount
        self.currency = currency
    }

    private enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case amount = "amount"
        case currency = "currency"
    }

    public var asRequestParam: [String: Any] {
        let param: [String: Any] = [CodingKeys.apiKey.rawValue: apiKey, CodingKeys.amount.rawValue: amount, CodingKeys.currency.rawValue: currency]
        return param.compactMapValues { $0 }
    }
}
