//
//  UserDefaultsSettingsRepository.swift
//  ToDoList
//
//  Created by Anton Kaizer on 28.01.26.
//

import Foundation

final class UserDefaultsSettingsRepository: SettingsRepository {
    var firstLaunch: Bool {
        get {
            UserDefaults.standard.bool(forKey: "firstLaunch")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "firstLaunch")
        }
    }
}
