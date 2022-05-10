//
//  CurrencyUsecase.swift
//  currency-converter
//
//  Created by JMC on 30/10/21.
//

import Foundation
import RxSwift

/* This is Currency usecase class implentation from AbstractCurrencyUsecase. Which will be used to get currency related data from currency repository*/
class CurrencyUsecase: AbstractCurrencyUsecase {
    let repository: AbstractRepository
    
    public init(repository: AbstractCurrencyRepository) {
        self.repository = repository
    }
    
    func convert(amount: String, currency: String) -> Observable<CurrencyApiRequest.ItemType> {
        return (repository as! AbstractCurrencyRepository).convert(amount: amount, currency: currency)
    }
}
