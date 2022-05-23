//
//  MockLocalStorageInteractor.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/23/22.
//

import Foundation
@testable import currency_converter

protocol MockLocalStorageInteractorChangable {
    func changeInteractor(interactor: AbstractLocalStorageIntereactor)
}

extension UserSessionDataClient: MockInteractorChangable {
    func changeIntegractor(interactor: AbstractLocalStorageIntereactor) {
        self.kvContainer = interactor
    }
}

class MockLocalStorageInteractor: AbstractLocalStorageIntereactor {
    static let shared: AbstractLocalStorageIntereactor = MockLocalStorageInteractor()
    
    var data = [String: Data]()
    
    func setData(keyValuePair: KeyValuePair) {
        data[keyValuePair.key] = keyValuePair.value
    }
    
    func getData(key: String) -> KeyValuePair {
        return KeyValuePair(key: key, value: data[key])
    }
    
    func create<T: Codable>(type: T.Type, item: T) -> Bool {
        return true
    }
    
    func createOrUpdate<T: Codable>(type: T.Type, item: T) -> Bool {
        return true
    }
    
    func createAll<T: Codable>(type: T.Type, items: [T]) -> Bool {
        return true
    }
    
    func read<T: Codable>(type: T.Type, id: String) -> T {
        return StubResponseProvider.getResponse(type: type)
    }
    
    func readAll<T: Codable>(type: T.Type) -> [T] {
        return [StubResponseProvider.getResponse(type: type)]
    }
    
    func update<T: Codable>(type: T.Type, item: T) -> Bool {
        return true
    }
    
    func updateAll<T: Codable>(type: T.Type, items: [T]) -> Bool {
        return true
    }
    
    func delete<T: Codable>(type: T.Type, item: T) -> Bool {
        return true
    }
    
    func deleteAll<T: Codable>(type: T.Type, items: [T]) -> Bool {
        return true 
    }
    
    func createOrUpdateKeyValuePair(keyValuePair: KeyValuePair) -> Bool {
        setData(keyValuePair: keyValuePair)
        return true
    }
    
    func readKeyValuePair(id: String) -> KeyValuePair {
        return getData(key: id)
    }
    
    
}
