//
//  MockEntityFactory.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/25/22.
//

import Foundation
@testable import currency_converter

class MockEntityFactory: EntityFactory {
    override func createList(type: ModelType) -> [AbstractDataModel] {
        var result = [AbstractDataModel] ()
        let dependency = BalanceDependency.shared
        
        if type == .balance {
            result =  [Balance(amount: dependency.totalEuro, currency: "EUR"), Balance(amount: dependency.totalUSD, currency: "USD"), Balance(amount: dependency.totalJPY, currency: "JPY")]
        }
        
        return result
    }
}

