//
//  AbstractUserSessionDataClient.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/11/22.
//

import Foundation


protocol AbstractUserSessionDataClient {
    static var shared: AbstractUserSessionDataClient {get}
    var kvContainer: AbstractKVLocalSorageIntereactor {get set}
    
    var conversionCount: Int {get}
    func setConversionCount(count: Int)
    func getConversionCount() -> Int
}
