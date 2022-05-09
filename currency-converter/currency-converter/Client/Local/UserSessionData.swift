//
//  UserSessionData.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/7/22.
//

import Foundation


protocol AbstractSessionData{
    associatedtype KVContainer: AbstractKVLocalSorageIntereactor
    static var shared: UserSessionData {get}
}

class UserSessionData {
    typealias KVContainer = UserDefaults
    class var kvContainerType: AbstractKVLocalSorageIntereactor.Type {
        return UserDefaults.self
    }
    static let shared = UserSessionData(kvContainer: kvContainerType.shared as! UserSessionData.KVContainer)
    public var kvContainer: AbstractKVLocalSorageIntereactor
    
    private init(kvContainer: KVContainer) {
        self.kvContainer = kvContainer
    }
    
    @KVLocalStorage(key: "conversionCount", defaultValue: 0, kvContainer: KVContainer.shared)
    var convertionCount: Int
}


class KCdata: UserSessionData {
    typealias KVContainer = KCdata
}
