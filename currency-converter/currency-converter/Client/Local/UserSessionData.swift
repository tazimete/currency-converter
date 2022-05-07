//
//  UserSessionData.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/7/22.
//

import Foundation
import UIKit


struct UserSessionData {
    static var shared = UserSessionData(kvContainer: UserDefaults.standard)
    private let kvContainer: AbstractKVLocalSorageIntereactor
    
    init(kvContainer: AbstractKVLocalSorageIntereactor) {
        self.kvContainer = kvContainer
    }
    
    @KVLocalStorage(key: "convertionCount", defaultValue: 0)
    static var convertionCount: Int
}
