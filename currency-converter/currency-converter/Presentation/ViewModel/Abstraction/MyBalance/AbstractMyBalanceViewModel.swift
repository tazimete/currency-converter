//
//  AbstractMyBalanceViewModel.swift
//  currency-converter
//
//  Created by AGM Tazimon 31/10/21.
//


import Foundation
import RxSwift

/* This is AbstractMyBalanceViewModel abstraction extented from AbstractViewModel. Which will be used to get balance related data by its usecases*/
protocol AbstractMyBalanceViewModel: AbstractViewModel {
    var commissionCalculator: ComissionCalculator {get}
    
    // Transform the my balance input to output observable
    func getMyBalanceOutput(input: MyBalanceViewModel.MyBalanceInput) -> MyBalanceViewModel.MyBalanceOutput
    
    // convert currency through api call
    func convert(amount: String, currency: String) -> Observable<CurrencyApiRequest.ItemType>
}
