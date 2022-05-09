//
//  KVLocalSorageIntereactor.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/7/22.
//

import Foundation

extension UserDefaults: AbstractKVLocalSorageIntereactor {
    static var shared: AbstractKVLocalSorageIntereactor {
        return standard
    }
    
    func set(key: String, value: Int) {
        self.set(value, forKey: key)
    }
    
    func set(key: String, value: Float) {
        self.set(value, forKey: key)
    }
    
    func set(key: String, value: Double) {
        self.set(value, forKey: key)
    }
    
    func set(key: String, value: String) {
        self.set(value, forKey: key)
    }
    
    func set(key: String, value: AnyObject) {
        self.set(value, forKey: key)
    }
    
    func set(key: String, value: Data) {
        self.set(value, forKey: key)
    }
    
    func set(key: String, value: URL?) {
        self.set(value, forKey: key)
    }
    
    func set(key: String, value: Any?) {
        self.set(value, forKey: key)
    }
    
    func getIntValue(forKey: String) -> Int {
        return self.integer(forKey: forKey)
    }
    
    func getFloatValue(forKey: String) -> Float {
        return self.float(forKey: forKey)
    }
    
    func getDoubleValue(forKey: String) -> Double {
        return self.double(forKey: forKey)
    }
    
    func getStringValue(forKey: String) -> String? {
        return self.string(forKey: forKey)
    }
    
    func getDataValue(forKey: String) -> Data? {
        return self.data(forKey: forKey)
    }
    
    func getURLValue(forKey: String) -> URL? {
        return self.url(forKey: forKey)
    }
    
    func getAnyObjectValue(forKey: String) -> Any? {
        return self.object(forKey: forKey)
    }
    
    func getAnyValue(forKey: String) -> Any? {
        return self.getAnyValue(forKey: forKey)
    }
    
    
}
