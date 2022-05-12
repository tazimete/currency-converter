//
//  KVLocalSorageIntereactor.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/7/22.
//

import Foundation

// TODO: Change this class to make common local data source client for UserDefault, KeyChain, Database
protocol AbstractLocalKVSorageInteractor {
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

protocol AbstractLocalDBSorageInteractor {
//    static var shared: AbstractLocalDBSorageInteractor {get}
    
    func create<T: NSObjectProtocol>(item: T) -> Bool
    func createAll<T>(items: [T]) -> Bool
    func read<ID, T>(item: ID) -> T
    func readAll<T>() -> [T]
    func update<T>(item: T) -> Bool
    func updateAll<T>(items: [T]) -> Bool
    func delete<T>(item: T) -> Bool
    func deleteAll<T>(items: [T]) -> Bool
}

typealias AbstractLocalStorageIntereactor = AbstractLocalKVSorageInteractor & AbstractLocalDBSorageInteractor
