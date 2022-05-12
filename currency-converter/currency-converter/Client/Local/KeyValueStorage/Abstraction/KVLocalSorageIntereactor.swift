//
//  KVLocalSorageIntereactor.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/7/22.
//

import Foundation
import UIKit

extension UserDefaults: AbstractLocalKVStorageInteractor {
    
    static var shared: AbstractLocalKVStorageInteractor {
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


class KeyValuePair: Codable {
    let key: String
    let value: Data
    
    init(key: String, value: Data) {
        self.key = key
        self.value = value
    }
}

extension UserDefaults: AbstractLocalDBStorageInteractor {
//    typealias T = KeyValuePair
//    typealias ID = String
//    static var shared: AbstractLocalDBStorageInteractor {
//        return UserDefaults.standard
//    }

    func create<T>(type: T.Type, item: T) -> Bool {
        let data = item as! KeyValuePair
        self.set(key: data.key, value: data.value)
        return true
    }

    func createAll<T>(type: T.Type, items: [T]) -> Bool {
        fatalError("Not Implemented Yet")
    }

    func read<T>(type: T.Type, id: String) -> T {
        return self.data(forKey: id) as! T
    }

    func readAll<T>(type: T.Type) -> [T] {
        fatalError("Not Implemented Yet")
    }

    func update<T>(type: T.Type, item: T) -> Bool {
        fatalError("Not Implemented Yet")
    }

    func updateAll<T>(type: T.Type, items: [T]) -> Bool {
        fatalError("Not Implemented Yet")
    }

    func delete<T>(type: T.Type, item: T) -> Bool {
        fatalError("Not Implemented Yet")
    }

    func deleteAll<T>(type: T.Type, items: [T]) -> Bool {
        fatalError("Not Implemented Yet")
    }
}
