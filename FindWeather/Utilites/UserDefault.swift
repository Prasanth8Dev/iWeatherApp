//
//  UserDefault.swift
//  Pcos
//
//  Created by Karthik Babu on 06/10/23.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let userDefaults = UserDefaults.standard

    private init() {}

    // MARK: - Define Keys for Your Data
    private let userNameKey = "UserName"
    private let userAgeKey = "UserAge"

    // MARK: - Save Data
    func saveUserName(_ name: String) {
        userDefaults.set(name, forKey: userNameKey)
    }

    func saveUserAge(_ age: Int) {
        userDefaults.set(age, forKey: userAgeKey)
    }

    // MARK: - Retrieve Data
    func getUserName() -> String? {
        return userDefaults.string(forKey: userNameKey)
    }

    func getUserAge() -> Int {
        return userDefaults.integer(forKey: userAgeKey)
    }

    // MARK: - Remove Data (if needed)
    func removeUserData() {
        userDefaults.removeObject(forKey: userNameKey)
        userDefaults.removeObject(forKey: userAgeKey)
    }
}



class UserDB {
    static let shared = UserDB()

    private let userDefaults = UserDefaults.standard

    private init() {}

    // MARK: - Save Data
    func setValue<T>(_ value: T, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    // MARK: - Retrieve Data
    func getValue<T>(forKey key: String) -> T? {
        return userDefaults.value(forKey: key) as? T
    }

    // MARK: - Remove Data (if needed)
    func removeValue(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}

