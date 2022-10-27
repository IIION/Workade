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
    func loadUserDefaults(key: String) -> Set<String> {
        if UserDefaults.standard.dictionaryRepresentation().keys.contains(key) {
            let value: Set<String> = decode(UserDefaults.standard.data(forKey: key) ?? Data())
            return value
        } else {
            let data = encode(Set<String>())
            UserDefaults.standard.set(data, forKey: key)
            return Set<String>()
        }
    }
    
    // save
    func saveUserDefaults(_ value: Set<String>, forKey: String) {
        let data = encode(value)
        UserDefaults.standard.set(data, forKey: forKey)
    }
    
    // update
    func updateUserDefaults(id: String, key: String) { // update
        var bookmarks: Set<String> = loadUserDefaults(key: key)
        if !bookmarks.contains(id) {
            bookmarks.insert(id)
        } else {
            bookmarks.remove(id)
        }
        saveUserDefaults(bookmarks, forKey: key)
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
