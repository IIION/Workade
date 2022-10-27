//
//  UserDefaultsManager.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/28.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    // load
    func loadUserDefaults<T: Codable>(key: String) -> Set<T> {
        if UserDefaults.standard.dictionaryRepresentation().keys.contains(key) {
            let value: Set<T> = decode(UserDefaults.standard.data(forKey: key) ?? Data())
            return value
        } else {
            let data = encode(Set<T>())
            UserDefaults.standard.set(data, forKey: key)
            return Set<T>()
        }
    }
    
    // save
    func saveUserDefaults(_ value: Set<Int>, forKey: String) {
        let data = encode(value)
        UserDefaults.standard.set(data, forKey: forKey)
    }
    
    // encoding
    func encode<T: Encodable>(_ from: T) -> Data {
        do {
            return try JSONEncoder().encode(from.self)
        } catch {
            fatalError("Unable to encode")
        }
    }
    
    // decoding
    func decode<T: Decodable>(_ data: Data) -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fatalError("Unable to decode")
        }
    }
}
