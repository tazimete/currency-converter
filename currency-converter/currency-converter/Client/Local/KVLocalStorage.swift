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
    private let kvContainer: AbstractKVLocalSorageIntereactor? = nil 

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
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
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
