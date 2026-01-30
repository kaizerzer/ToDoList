//
//  DependencyContainer.swift
//  ToDoList
//
//  Created by Anton Kaizer on 28.01.26.
//

import Foundation

struct DependencyContainer {
    let toDoService: ToDoService
    let toDoRepository: ToDoRepository
    let settingsRepository: SettingsRepository
    
    let router: Router
}
