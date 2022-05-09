//
//  UserSessionData.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/7/22.
//

import Foundation


protocol AbstractSessionData{
    associatedtype KVContainer: AbstractKVLocalSorageIntereactor
//    static var shared: UserSessionData {get}
}

class UserSessionData: AbstractSessionData {
    typealias KVContainer = UserDefaults
    class var kvContainerType: AbstractKVLocalSorageIntereactor.Type {
        return UserDefaults.self
    }
    
    private static let instance = UserSessionData(kvContainer: kvContainerType.shared as! UserSessionData.KVContainer)
    class var shared: UserSessionData {
        return instance
    }
    public let kvContainer: AbstractKVLocalSorageIntereactor = getType().shared
    
    public init(kvContainer: AbstractKVLocalSorageIntereactor) {
//        self.kvContainer = kvContainer
    }
    
    class func getType() -> AbstractKVLocalSorageIntereactor.Type {
        return UserDefaults.self
    }
    
    @KVLocalStorage(key: "conversionCount", defaultValue: 0, kvContainer: getType().shared)
    static var conversionCount: Int
}


class KCdata: UserSessionData {
    typealias KVContainer = Mock
    override class var kvContainerType: AbstractKVLocalSorageIntereactor.Type {
        return Mock.self
    }
    
    private static let instance = KCdata()
    override class var shared: UserSessionData {
        return instance
    }
    
    required init() {
        super.init(kvContainer: UserDefaults.shared as! UserSessionData.KVContainer)
    }
    
    override class func getType() -> AbstractKVLocalSorageIntereactor.Type {
        return Mock.self
    }
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
