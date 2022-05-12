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
    
    required init(){
        
    }
    
    func set(key: String, value: Int) {
        return
    }
    
    func set(key: String, value: Float) {
        return
    }
    
    func set(key: String, value: Double) {
        return
    }
    
    func set(key: String, value: Bool) {
        return
    }
    
    
    func set(key: String, value: String) {
        return
    }
    
    func set(key: String, value: AnyObject) {
        return
    }
    
    func set(key: String, value: Data) {
        return
    }
    
    func set(key: String, value: URL?) {
        return
    }
    
    func set(key: String, value: Any?) {
        return
    }
    
    func getIntValue(forKey: String) -> Int {
        return 0
    }
    
    func getFloatValue(forKey: String) -> Float {
        return 0
    }
    
    func getDoubleValue(forKey: String) -> Double {
        return 0
    }
    
    func getDoubleValue(forKey: String) -> Bool {
        return true
    }
    
    func getStringValue(forKey: String) -> String? {
        return  nil
    }
    
    func getAnyObjectValue(forKey: String) -> Any? {
        return  6666
    }
    
    func getDataValue(forKey: String) -> Data? {
        return  "5555".data(using: .utf8)
    }
    
    func getURLValue(forKey: String) -> URL? {
        return  nil
    }
    
    func getAnyValue(forKey: String) -> Any? {
        return  nil
    }
    
    
}
