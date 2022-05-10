//
//  ComissionPolicy.swift
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

struct FirstFiveConversionComissionPolicy: ComissionPolicy {
    func hasComission(conversionSerial: Int, conversionAmount: Double) -> Bool {
        if conversionSerial <= 5 {
            return false
        }
        
        return true
    }
    
    func getComissionAmount(conversionSerial: Int, conversionAmount: Double) -> Double {
        var result = 0.0
        
        if hasComission(conversionSerial: conversionSerial, conversionAmount: conversionAmount) {
            result = (conversionAmount*0.7)/100
        }
        
        return result
    }
    
    func getComissionPercent(conversionSerial: Int, conversionAmount: Double) -> Double {
        var result = 0.0
        
        if hasComission(conversionSerial: conversionSerial, conversionAmount: conversionAmount) {
            result = 0.7
        }
        
        return result
    }
}
