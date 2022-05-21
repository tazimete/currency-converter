//
//  KVLocalSorageIntereactor.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/7/22.
//

import Foundation


/**
 This protocol will used as interactor to key value storage
 **/
protocol AbstractLocalKVStorageInteractor {
    static var shared: AbstractLocalKVStorageInteractor {get}
    
    func setData(keyValuePair: KeyValuePair)
    func getData(key: String) -> KeyValuePair
}

/**
 This protocol will used as interactor to local database 
 **/
protocol AbstractLocalDBStorageInteractor {
//    static var shared: AbstractLocalDBSorageInteractor {get}
    
    func create<T>(type: T.Type, item: T) -> Bool
    func createOrUpdate<T>(type: T.Type, item: T) -> Bool
    func createAll<T>(type: T.Type, items: [T]) -> Bool
    func read<T>(type: T.Type, id: String) -> T
    func readAll<T>(type: T.Type) -> [T]
    func update<T>(type: T.Type, item: T) -> Bool
    func updateAll<T>(type: T.Type, items: [T]) -> Bool
    func delete<T>(type: T.Type, item: T) -> Bool
    func deleteAll<T>(type: T.Type, items: [T]) -> Bool
    
    func createOrUpdateKeyValuePair(keyValuePair: KeyValuePair) -> Bool
    func readKeyValuePair(id: String) -> KeyValuePair
}

typealias AbstractLocalStorageIntereactor = AbstractLocalKVStorageInteractor & AbstractLocalDBStorageInteractor
