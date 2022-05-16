//
//  Movie.swift
//  currency-converter
//
//  Created by AGM Tazimon 31/10/21.
//

import Foundation

/* Currency entity of search response */
struct Currency: AbstractDataModel, Codable {
    public var id: Int?
    public let amount: String?
    public let title: String?
    
    init(amount: String? = nil, title: String? = nil) {
        self.amount = amount
        self.title = title
    }
    
    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case title = "currency"
    }
    
    public var asDictionary : [String: Any] {
        return [CodingKeys.amount.rawValue: amount ?? "", CodingKeys.title.rawValue: title ?? ""]
    }
    
    public var asCellViewModel: AbstractCellViewModel {
        return CurrencyCellViewModel(title: "\(amount ?? "") \(title ?? "")")
    }
}


