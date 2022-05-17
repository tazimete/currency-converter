//
//  Movie.swift
//  currency-converter
//
//  Created by AGM Tazimon 31/10/21.
//

import Foundation

/* Balance entity of presentation/application layer */
struct Balance: AbstractDataModel, Codable {
    public var id: Int?
    public let amount: String?
    public let currency: String?
    
    init(amount: String? = nil, currency: String? = nil) {
        self.amount = amount
        self.currency = currency
    }
    
    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case currency = "currency"
    }
    
    public var asDictionary : [String: Any] {
        return [CodingKeys.amount.rawValue: amount ?? "", CodingKeys.currency.rawValue: currency ?? ""]
    }
    
    public var asCellViewModel: AbstractCellViewModel {
        return CurrencyCellViewModel(title: "\(amount ?? "") \(currency ?? "")")
    }
}


