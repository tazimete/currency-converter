//
//  UserSessionData.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/7/22.
//

import Foundation
import UIKit


class UserSessionData {
    static public let shared = UserSessionData(kvContainer: UserDefaults.standard)
    private let kvContainer: AbstractKVLocalSorageIntereactor
    
    init(kvContainer: AbstractKVLocalSorageIntereactor) {
        self.kvContainer = kvContainer
    }
    
    @KVLocalStorage(key: "conversionCount", defaultValue: 0, kvContainer: UserSessionData.shared.kvContainer)
     static var convertionCount: Int
}
