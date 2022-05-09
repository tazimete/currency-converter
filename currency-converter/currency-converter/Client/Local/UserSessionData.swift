//
//  UserSessionData.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/7/22.
//

import Foundation


class UserSessionData {
    static public let shared = UserSessionData(kvContainer: UserDefaults.standard)
    public var kvContainer: AbstractKVLocalSorageIntereactor
    
    private init(kvContainer: AbstractKVLocalSorageIntereactor) {
        self.kvContainer = kvContainer
    }
    
    @KVLocalStorage(key: "conversionCount", defaultValue: 0, kvContainer: UserSessionData.shared.kvContainer)
     static var convertionCount: Int
}
