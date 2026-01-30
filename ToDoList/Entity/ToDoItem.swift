//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Anton Kaizer on 28.01.26.
//

import Foundation

struct ToDoItem: Identifiable, Hashable {
    var id: String
    var title: String
    var description: String?
    var completed: Bool
    var date: Date
}
