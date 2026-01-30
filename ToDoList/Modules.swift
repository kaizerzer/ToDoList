//
//  Modules.swift
//  ToDoList
//
//  Created by Anton Kaizer on 30.01.26.
//


enum Module: Hashable {
    case ToDoList
    case ToDoDetail(toDo: ToDoItem?)
}
