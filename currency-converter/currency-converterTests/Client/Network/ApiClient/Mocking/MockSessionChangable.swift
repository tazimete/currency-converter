//
//  MockSessionable.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/23/22.
//

import Foundation
@testable import currency_converter


protocol MockSessionChangable {
    func changeMockSession(session: AbstractURLSession)
}

extension ApiClient: MockSessionChangable {
    func changeMockSession(session: AbstractURLSession) {
        self.session = session
    }
}

extension MockAPIClient: MockSessionChangable {
    func changeMockSession(session: AbstractURLSession) {
        self.session = session
    }
}
