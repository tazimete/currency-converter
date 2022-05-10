//
//  Abstraction.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/10/22.
//

import Foundation


protocol ComissionApplicable {
    func hasComission(conversionSerial: Int, conversionAmount: Double) -> Bool
}

protocol ComissionAmount {
    func getComissionAmount(conversionSerial: Int, conversionAmount: Double) -> Double
    func getComissionPercent(conversionSerial: Int, conversionAmount: Double) -> Double
}

typealias ComissionPolicy = ComissionApplicable & ComissionAmount
