//
//  MyBalanceViewModel.swift
//  currency-converter
//
//  Created by AGM Tazim on 30/10/21.
//

import Foundation
import RxSwift
import RxCocoa

/* This is my balance viewmodel class implementation of AbstractMyBalanceViewModel. Which will be used to get my blalance related data by its usecase*/
class MyBalanceViewModel: AbstractMyBalanceViewModel {
    typealias DomainEntity = Balance
    
    // This struct will be used get input from viewcontroller
    public struct CurrencyConverterInput {
        let fromAmount: String
        let fromCurrency: String
        let toCurrency: String
    }
    
    // This struct will be used get event with data from viewcontroller
    public struct MyBalanceInput {
        let currencyConverterTrigger: Observable<CurrencyConverterInput>
    }
    
    // This struct will be used to send event with observable data/response to viewcontroller
    public struct MyBalanceOutput {
        let balance: BehaviorRelay<DomainEntity?>
        let errorTracker: BehaviorRelay<NetworkError?>
    }
    
    let usecase: AbstractUsecase
    let commissionCalculator: ComissionCalculator
    
    public init(usecase: AbstractCurrencyUsecase, commissionCalculator: ComissionCalculator) {
        self.usecase = usecase
        self.commissionCalculator = commissionCalculator
    }
    
    public func getMyBalanceOutput(input: MyBalanceInput) -> MyBalanceOutput {
        let balanceResponse = BehaviorRelay<DomainEntity?>(value: nil)
        let errorResponse = BehaviorRelay<NetworkError?>(value: nil) 
        
        input.currencyConverterTrigger.flatMapLatest({ [weak self] (inputModel) -> Observable<CurrencyApiRequest.ItemType> in
            guard let weakSelf = self else {
                return Observable.just(CurrencyApiRequest.ItemType())
            }
            
            //fetch movie list
            return weakSelf.convert(fromAmount: inputModel.fromAmount, fromCurrency: inputModel.fromCurrency, toCurrency: inputModel.toCurrency)
                   .catch({ error in
                       errorResponse.accept(error as? NetworkError)
                       return Observable.just(CurrencyApiRequest.ItemType())
                    })
        }).subscribe(onNext: { response in
            balanceResponse.accept(DomainEntity(amount: response.amount, currency: response.title))
        }, onError: { [weak self] error in
            errorResponse.accept(error as? NetworkError)
        }, onCompleted: nil, onDisposed: nil)
        
        return MyBalanceOutput.init(balance: balanceResponse, errorTracker: errorResponse)
    }
    
    func convert(fromAmount: String, fromCurrency: String, toCurrency: String) -> Observable<CurrencyApiRequest.ItemType> {
        return (usecase as! AbstractCurrencyUsecase).convert(fromAmount: fromAmount, fromCurrency: fromCurrency, toCurrency: toCurrency)
    }
}

