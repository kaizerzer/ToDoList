//
//  SettingsRepository.swift
//  ToDoList
//
//  Created by Anton Kaizer on 28.01.26.
//

protocol SettingsRepository: AnyObject {
    var firstLaunch: Bool { get set }
}
