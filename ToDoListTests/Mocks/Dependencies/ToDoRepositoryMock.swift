//
//  ToDoRepositoryMock.swift
//  ToDoList
//
//  Created by Anton Kaizer on 30.01.26.
//

@testable import ToDoList

class ToDoRepositoryMock: ToDoRepository {
    var saveToDoItemsCompletion: (((any Error)?) -> Void)?
    func saveToDoItems(_ items: [ToDoList.ToDoItem], _ completion: @escaping ((any Error)?) -> Void) {
        self.saveToDoItemsCompletion = completion
    }
    
    var deleteToDoItemCompletion: (((any Error)?) -> Void)?
    func deleteToDoItem(_ item: ToDoList.ToDoItem, _ completion: @escaping ((any Error)?) -> Void) {
        self.deleteToDoItemCompletion = completion
    }
    
    var getAllToDoItemsCompletion: (([ToDoList.ToDoItem], (any Error)?) -> Void)?
    func getAllToDoItems(_ completion: @escaping ([ToDoList.ToDoItem], (any Error)?) -> Void) {
        self.getAllToDoItemsCompletion = completion
    }
    
    var searchToDoItemsCompletion: (([ToDoList.ToDoItem], (any Error)?) -> Void)?
    func searchToDoItems(_ text: String, _ completion: @escaping ([ToDoList.ToDoItem], (any Error)?) -> Void) {
        self.searchToDoItemsCompletion = completion
    }
}
