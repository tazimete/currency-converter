//
//  StubbedResponse.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/22/22.
//

import Foundation

let currencyExchangeSuccessResponse: [String: Any] = ["amount": "45875","currency": "JPY"]
let currencyExchangeFailedResponse = ["error": "invalid_parameters", "error_description": "Can not parse amount or currency BTH"]
let currencyExchangeValidationFailedResponse = ["error": "insufficient_balance", "error_description": "You dont have enough balance to exchange include 0.7% comission"]
