//
//  MockCurrencyRepository.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/23/22.
//

@testable import currency_converter
import RxSwift

class MockCurrencyUsecase: AbstractCurrencyUsecase {
    let repository: AbstractRepository
    
    public init(repository: AbstractCurrencyRepository) {
        self.repository = repository
    }
    
    func convert(fromAmount: String, fromCurrency: String, toCurrency: String) -> Observable<CurrencyApiRequest.ItemType> {
        return (repository as! AbstractCurrencyRepository).get(fromAmount: fromAmount, fromCurrency: fromCurrency, toCurrency: toCurrency)
    }
}
