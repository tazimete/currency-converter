//
//  MockDatabaseClient.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/23/22.
//

@testable import currency_converter


protocol MockInteractorChangable {
    func changeIntegractor(interactor: AbstractLocalStorageIntereactor)
}

extension DatabaseClient: MockInteractorChangable {
    func changeIntegractor(interactor: AbstractLocalStorageIntereactor) {
        self.interactor = interactor
    }
}
