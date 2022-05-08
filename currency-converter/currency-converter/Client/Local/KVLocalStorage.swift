//
//  LocalStorage.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/7/22.
//

import Foundation

@propertyWrapper
struct KVLocalStorage<T: Codable> {
    private let key: String
    private let defaultValue: T
    private let kvContainer: AbstractKVLocalSorageIntereactor

//    @available(*, unavailable,
//            message: "@Proxy can only be applied to classes"
//        )
//        var wrappedValue: T {
//            get { fatalError() }
//            set { fatalError() }
//        }
//
//        static subscript(
//            _enclosingInstance instance: UserSessionData,
//            wrapped wrappedKeyPath: ReferenceWritableKeyPath<UserSessionData, T>,
//            storage storageKeyPath: ReferenceWritableKeyPath<UserSessionData, Self>
//        ) -> T {
//            get {
//                let propertyWrapper = instance[keyPath: storageKeyPath]
//                let key = propertyWrapper.key
//                let defaultValue = propertyWrapper.defaultValue
//                return instance.kvContainer.getDataValue(forKey: key) as? T ?? defaultValue
//            }
//            set {
//                let propertyWrapper = instance[keyPath: storageKeyPath]
//                let key = propertyWrapper.key
//                instance.kvContainer.set(key: key, value: newValue)
//            }
//        }
    

    init(key: String, defaultValue: T, kvContainer: AbstractKVLocalSorageIntereactor) {
        self.key = key
        self.defaultValue = defaultValue
        self.kvContainer = kvContainer
    }

    var wrappedValue: T {
        get {
            // Read value from storage
            guard let data = self.kvContainer.getDataValue(forKey: key) else {
                // Return defaultValue when no data in storgae
                return defaultValue
            }

            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)

            // Set value to stoarge
            self.kvContainer.set(key: key, value: data)
        }
    }
}
