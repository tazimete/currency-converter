//
//  KVLocalSorageIntereactor.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/7/22.
//

import Foundation


// TODO: Change this class to make common local data source client for UserDefault, KeyChain, Database
protocol AbstractLocalSorageIntereactor: AnyObject {
    init()
    static var shared: AbstractLocalSorageIntereactor {get}
    
    func set(key: String, value: Int)
    func set(key: String, value: Float)
    func set(key: String, value: Double)
    func set(key: String, value: String)
    func set(key: String, value: AnyObject)
    func set(key: String, value: Data)
    func set(key: String, value: URL?)
    func set(key: String, value: Any?)
    
    func getIntValue(forKey: String) -> Int
    func getFloatValue(forKey: String) -> Float
    func getDoubleValue(forKey: String) -> Double
    func getStringValue(forKey: String) -> String?
    func getAnyObjectValue(forKey: String) -> Any?
    func getDataValue(forKey: String) -> Data?
    func getURLValue(forKey: String) -> URL?
    func getAnyValue(forKey: String) -> Any?
}

