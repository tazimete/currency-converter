//
//  UserSessionData.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/7/22.
//

import Foundation


class UserSessionDataClient: AbstractUserSessionDataClient {
    public static let shared: AbstractUserSessionDataClient = UserSessionDataClient(kvContainer: UserDefaults.standard)
    public var kvContainer: AbstractLocalDBStorageInteractor
    
    private init(kvContainer: AbstractLocalDBStorageInteractor) {
        self.kvContainer = kvContainer
    }
    
    @KVLocalStorage(key: "conversionCount", defaultValue: 0)
    var conversionCount: Int
    
    func setConversionCount(count: Int) {
        conversionCount = count
    }
    
    func getConversionCount() -> Int {
        return conversionCount
    }
}

class MockUserSessionData: AbstractLocalKVStorageInteractor {
    
    static var shared: AbstractLocalKVStorageInteractor {
        return MockUserSessionData()
    }
    
    var data:[String: Data?] = [:]
    
    required init(){
        
    }
    
    func setData(keyValuePair: KeyValuePair) {
        self.data[keyValuePair.key] = keyValuePair.value
    }
    
    func getData(key: String) -> KeyValuePair {
        return KeyValuePair(key: key, value: data[key] as? Data)
    }
}
