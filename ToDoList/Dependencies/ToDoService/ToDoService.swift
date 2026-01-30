//
//  ToDoService.swift
//  ToDoList
//
//  Created by Anton Kaizer on 28.01.26.
//

protocol ToDoService {
    func loadToDoItem(_ completion: @escaping ([ToDoItem], (any Error)?) -> Void)
}

