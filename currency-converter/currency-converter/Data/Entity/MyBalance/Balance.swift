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
    public var amount: Double?
    public var currency: String?
    
    init(amount: Double? = nil, currency: String? = nil) {
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
        var viewModel = CurrencyCellViewModel(title: "\(currency ?? "")")
        
        if let amount = amount {
            viewModel = CurrencyCellViewModel(title: "\(amount ?? 0.00) \(currency ?? "")")
        }
        
        return viewModel 
    }
}


