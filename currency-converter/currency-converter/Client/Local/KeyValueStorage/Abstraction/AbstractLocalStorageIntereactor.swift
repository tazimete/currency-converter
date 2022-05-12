//
//  KVLocalSorageIntereactor.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/7/22.
//

import Foundation

// TODO: Change this class to make common local data source client for UserDefault, KeyChain, Database
protocol AbstractLocalKVStorageInteractor {
//    static var shared: AbstractLocalKVSorageInteractor {get}
    
    func set(key: String, value: Int)
    func set(key: String, value: Float)
    func set(key: String, value: Double)
    func set(key: String, value: Bool)
    func set(key: String, value: String)
    func set(key: String, value: AnyObject)
    func set(key: String, value: Data)
    func set(key: String, value: URL?)
    func set(key: String, value: Any?)
    
    func getIntValue(forKey: String) -> Int
    func getFloatValue(forKey: String) -> Float
    func getDoubleValue(forKey: String) -> Double
    func getDoubleValue(forKey: String) -> Bool
    func getStringValue(forKey: String) -> String?
    func getAnyObjectValue(forKey: String) -> Any?
    func getDataValue(forKey: String) -> Data?
    func getURLValue(forKey: String) -> URL?
    func getAnyValue(forKey: String) -> Any?
}

protocol AbstractLocalDBStorageInteractor {
//    static var shared: AbstractLocalDBSorageInteractor {get}
    
    func create<T>(type: T.Type, item: T) -> Bool
    func createAll<T>(type: T.Type, items: [T]) -> Bool
    func read<T>(type: T.Type, id: String) -> T
    func readAll<T>(type: T.Type) -> [T]
    func update<T>(type: T.Type, item: T) -> Bool
    func updateAll<T>(type: T.Type, items: [T]) -> Bool
    func delete<T>(type: T.Type, item: T) -> Bool
    func deleteAll<T>(type: T.Type, items: [T]) -> Bool
}

typealias AbstractLocalStorageIntereactor = AbstractLocalKVStorageInteractor & AbstractLocalDBStorageInteractor
