//
//  ComissionPolicy.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/10/22.
//

import Foundation


protocol ComissionPolicy {
    func hasComission(conversionSerial: Int, conversionAmount: Double) -> Bool
}

protocol ComissionAmount {
    func getComissionAmount(conversionSerial: Int, conversionAmount: Double) -> Bool
}
