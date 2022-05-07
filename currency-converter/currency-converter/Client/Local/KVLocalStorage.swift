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

    init(key: String, defaultValue: T, kvContainer: AbstractKVLocalSorageIntereactor = UserDefaults.standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.kvContainer = kvContainer
    }

    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = self.kvContainer.getDataValue(forKey: key) else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }

            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)
            
            // Set value to UserDefaults
            self.kvContainer.set(key: key, value: data)
        }
    }
}
