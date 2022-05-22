//
//  MockLocalStorageInteractor.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/23/22.
//

import Foundation
@testable import currency_converter


class MockLocalStorageInteractor: AbstractLocalStorageIntereactor {
    static let shared: AbstractLocalKVStorageInteractor = MockLocalStorageInteractor()
    
    var data = [String: Any]()
    
    func setData(keyValuePair: KeyValuePair) {
        data[keyValuePair.key] = keyValuePair.value
    }
    
    func getData(key: String) -> KeyValuePair {
        return KeyValuePair(key: key, value: data[key])
    }
    
    func create<T>(type: T.Type, item: T) -> Bool {
        fatalError("Not Implemented Yet")
    }
    
    func createOrUpdate<T>(type: T.Type, item: T) -> Bool {
        fatalError("Not Implemented Yet")
    }
    
    func createAll<T>(type: T.Type, items: [T]) -> Bool {
        fatalError("Not Implemented Yet")
    }
    
    func read<T>(type: T.Type, id: String) -> T {
        fatalError("Not Implemented Yet")
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
    
    func createOrUpdateKeyValuePair(keyValuePair: KeyValuePair) -> Bool {
        setData(keyValuePair: keyValuePair)
        return true
    }
    
    func readKeyValuePair(id: String) -> KeyValuePair {
        return getData(key: id)
    }
    
    
}
