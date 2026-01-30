//
//  ToDoRepository.swift
//  ToDoList
//
//  Created by Anton Kaizer on 28.01.26.
//

protocol ToDoRepository {
    func saveToDoItems(_ items: [ToDoItem], _ completion: @escaping (Error?) -> Void)
    func deleteToDoItem(_ item: ToDoItem, _ completion: @escaping (Error?) -> Void)
    func getAllToDoItems(_ completion: @escaping ([ToDoItem], Error?) -> Void)
    func searchToDoItems(_ text: String, _ completion: @escaping ([ToDoItem], Error?) -> Void)
}
