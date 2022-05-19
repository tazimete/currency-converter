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
        let balance: BehaviorRelay<Balance?>
        let errorTracker: BehaviorRelay<NetworkError?>
    }
    
    let disposeBag =  DisposeBag()
    let usecase: AbstractUsecase
    let commissionCalculator: ComissionCalculator
    let balanceListRelay: BehaviorRelay<[Balance]> = BehaviorRelay<[Balance]>(value: [Balance(amount: 1000.00, currency: "USD"), Balance(amount: 100, currency: "EUR"), Balance(amount: 100, currency: "JPY"), Balance(amount: 100, currency: "BDT")])
    let currencyExchange: CurrencyExchange = CurrencyExchange()
    
    public init(usecase: AbstractCurrencyUsecase, commissionCalculator: ComissionCalculator) {
        self.usecase = usecase
        self.commissionCalculator = commissionCalculator
    }
    
    public func getMyBalanceOutput(input: MyBalanceInput) -> MyBalanceOutput {
        let balanceResponse = BehaviorRelay<Balance?>(value: nil)
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
            // check if  self is exists and balance is enough
            guard let weakSelf = self, let balance = weakSelf.currencyExchange.sell, weakSelf.hasEnoughBalance(balance: balance) == true else {
                return Observable.just(CurrencyApiRequest.ItemType())
            }
            
            //convert currency with balance
            return weakSelf.convert(fromAmount: inputModel.fromAmount, fromCurrency: inputModel.fromCurrency, toCurrency: inputModel.toCurrency)
                   .catch({ error in
                       errorResponse.accept(error as? NetworkError)
                       return Observable.just(CurrencyApiRequest.ItemType())
                    })
        }).subscribe(onNext: { [weak self] response in
            guard let weakSelf = self else {
                return
            }
            
            let output = Balance(amount: Double(response.amount ?? "0.00") ?? 0.00, currency: response.title)
            weakSelf.currencyExchange.receive = output
            weakSelf.balanceListRelay.accept(weakSelf.calculatFinalBalance(exchangedBalance: weakSelf.currencyExchange))
            balanceResponse.accept(output)
        }, onError: { [weak self] error in
            errorResponse.accept(error as? NetworkError)
        }).disposed(by: disposeBag)
        
        return MyBalanceOutput.init(balance: balanceResponse, errorTracker: errorResponse)
    }
    
    // MARK: API CALLS
    func convert(fromAmount: String, fromCurrency: String, toCurrency: String) -> Observable<CurrencyApiRequest.ItemType> {
        return (usecase as! AbstractCurrencyUsecase).convert(fromAmount: fromAmount, fromCurrency: fromCurrency, toCurrency: toCurrency)
    }
    
    // MARK: HELPER METHODS
    // check enough balance before exchange
    func hasEnoughBalance(balance: Balance) -> Bool {
        var result = true
        let balances = balanceListRelay.value
        let currency = currencyExchange.sell?.currency ?? ""
        let amount = balance.amount ?? 0.00
        
        //set deduct amount
        if let index = balances.firstIndex(where: { $0.currency?.elementsEqual(currency) ?? false}) {
            let diff = (balances[index].amount ?? 0.0) - amount
            result = diff >= 0 ? true : false
        }
        
        return result
    }
    
    // deduct and increase balance after exchange
    func calculatFinalBalance(exchangedBalance: CurrencyExchange) -> [Balance] {
        var balances = balanceListRelay.value
        let sellCurrency = exchangedBalance.sell?.currency ?? ""
        let receiveCurrency = exchangedBalance.receive?.currency ?? ""
        let sellAmount = exchangedBalance.sell?.amount ?? 0.00
        let receiveAmount = exchangedBalance.receive?.amount ?? 0.00
        
        // set recieve amount
        if let index = balances.firstIndex(where: { $0.currency?.elementsEqual(receiveCurrency) ?? false}) {
            balances[index].amount = (balances[index].amount ?? 0.0) + receiveAmount
        }
        
        //set deduct amount from sell balance
        if let index = balances.firstIndex(where: { $0.currency?.elementsEqual(sellCurrency) ?? false}) {
            balances[index].amount = (balances[index].amount ?? 0.0) - sellAmount
        }
        
        return balances
    }
}

