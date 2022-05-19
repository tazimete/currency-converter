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
        let addCurrencyTrigger: Observable<Balance>
    }
    
    // This struct will be used to send event with observable data/response to viewcontroller
    public struct MyBalanceOutput {
        let balance: BehaviorRelay<DomainEntity?>
        let errorTracker: BehaviorRelay<NetworkError?>
    }
    
    var disposeBag =  DisposeBag()
    let usecase: AbstractUsecase
    let commissionCalculator: ComissionCalculator
    let balanceListRelay: BehaviorRelay<[Balance]> = BehaviorRelay<[Balance]>(value: [Balance(amount: 1000.00, currency: "USD"), Balance(amount: 100, currency: "EUR"), Balance(amount: 100, currency: "JPY"), Balance(amount: 100, currency: "BDT")])
    private(set) var currencyExchange: CurrencyExchange? = CurrencyExchange()
    
    public init(usecase: AbstractCurrencyUsecase, commissionCalculator: ComissionCalculator) {
        self.usecase = usecase
        self.commissionCalculator = commissionCalculator
    }
    
    public func getMyBalanceOutput(input: MyBalanceInput) -> MyBalanceOutput {
        let balanceResponse = BehaviorRelay<DomainEntity?>(value: nil)
        let errorResponse = BehaviorRelay<NetworkError?>(value: nil) 
        
        //add currency trigger
        input.addCurrencyTrigger
            .subscribe(onNext: { [weak self] balance in
                guard let weakSelf = self else {
                    return
                }
                
                let values = weakSelf.balanceListRelay.value
                weakSelf.balanceListRelay.accept(values + [balance])
        }).disposed(by: disposeBag)
        
        // currency exchange trigger
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
            balanceResponse.accept(DomainEntity(amount: Double(response.amount ?? "0.00") ?? 0.00, currency: response.title))
        }, onError: { [weak self] error in
            errorResponse.accept(error as? NetworkError)
        }).disposed(by: disposeBag)
        
        return MyBalanceOutput.init(balance: balanceResponse, errorTracker: errorResponse)
    }
    
    func convert(fromAmount: String, fromCurrency: String, toCurrency: String) -> Observable<CurrencyApiRequest.ItemType> {
        return (usecase as! AbstractCurrencyUsecase).convert(fromAmount: fromAmount, fromCurrency: fromCurrency, toCurrency: toCurrency)
    }
    
    // deduct and increase balance after exchange 
    func calculatOutputBalance(output: DomainEntity) {
        currencyExchange?.receive = output
        
        var result = balanceListRelay.value
        
        // set recieve amount
        if let index = balanceListRelay.value.firstIndex(where: { $0.currency?.elementsEqual(output.currency ?? "") ?? false}) {
            result[index].amount = (result[index].amount ?? 0.0) + (output.amount ?? 0.00)
            balanceListRelay.accept(result)
        }
        
        //set deduct amount
        if let index = balanceListRelay.value.firstIndex(where: { $0.currency?.elementsEqual(currencyExchange?.sell?.currency ?? "") ?? false}) {
            result[index].amount = (result[index].amount ?? 0.0) - (currencyExchange?.sell?.amount ?? 0.00)
            balanceListRelay.accept(result)
        }
    }
}

