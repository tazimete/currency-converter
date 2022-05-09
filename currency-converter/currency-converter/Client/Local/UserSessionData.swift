//
//  UserSessionData.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/7/22.
//

import Foundation


class UserSessionData {
    public static let shared = UserSessionData(kvContainer: UserDefaults.shared)
    public var kvContainer: AbstractKVLocalSorageIntereactor
    
    private init(kvContainer: AbstractKVLocalSorageIntereactor) {
        self.kvContainer = kvContainer
    }
    
    @KVLocalStorage(key: "conversionCount", defaultValue: 0)
    var conversionCount: Int
}

class Mock: AbstractKVLocalSorageIntereactor {
    static var shared: AbstractKVLocalSorageIntereactor {
        return Mock()
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
