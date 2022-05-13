//
//  AbstractCurrencyRepository.swift
//  currency-converter
//
//  Created by AGM Tazimon 30/10/21.
//

import Foundation
import RxSwift

/* This is Currency repository abstraction extented from AbstractRepository. Which will be used to get currency related data from api client/server response*/
protocol AbstractCurrencyRepository: AbstractRepository {
     func get(amount: String, currency: String) -> Observable<CurrencyApiRequest.ItemType>
}
