//
//  KVLocalSorageIntereactor.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/7/22.
//

import Foundation
import UIKit

extension UserDefaults: AbstractLocalKVSorageInteractor {
    
    static var shared: AbstractLocalKVSorageInteractor {
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
    
    func set(key: String, value: Bool) {
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
    
    func getDoubleValue(forKey: String) -> Bool {
        return self.bool(forKey: forKey)
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


class KeyValuePair: NSObject{
    let key: String
    let value: Data
    
    init(key: String, value: Data) {
        self.key = key
        self.value = value
    }
}

extension UserDefaults: AbstractLocalDBSorageInteractor {
    
//    static var shared: AbstractLocalDBSorageInteractor {
//        return UserDefaults.standard
//    }

    func create<T>(item: T) -> Bool where T: NSObjectProtocol {
        let data = item as! KeyValuePair
        self.set(key: data.key, value: data.value)
        return true
    }

    func createAll<T>(items: [T]) -> Bool {
        fatalError("Not Implemented Yet")
    }

    func read<ID, T>(item: ID) -> T {
        fatalError("Not Implemented Yet")
    }

    func readAll<T>() -> [T] {
        fatalError("Not Implemented Yet")
    }

    func update<T>(item: T) -> Bool {
        fatalError("Not Implemented Yet")
    }

    func updateAll<T>(items: [T]) -> Bool {
        fatalError("Not Implemented Yet")
    }

    func delete<T>(item: T) -> Bool {
        fatalError("Not Implemented Yet")
    }

    func deleteAll<T>(items: [T]) -> Bool {
        fatalError("Not Implemented Yet")
    }
}
