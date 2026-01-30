//
//  ToDoListInteractorMock.swift
//  ToDoList
//
//  Created by Anton Kaizer on 30.01.26.
//

@testable import ToDoList

class ToDoListInteractorMock: ToDoListInteractorProtocol {
    var performInitialLoadingIfNeededCompletion: (((any Error)?, @escaping () -> Void) -> Void)?
    func performInitialLoadingIfNeeded(_ completion: @escaping ((any Error)?, @escaping () -> Void) -> Void) {
        self.performInitialLoadingIfNeededCompletion = completion
    }
    
    var getToDoListCompletion: (([ToDoItem], (any Error)?) -> Void)?
    func getToDoList(_ completion: @escaping ([ToDoItem], (any Error)?) -> Void) {
        self.getToDoListCompletion = completion
    }
    
    var deleteToDoItemCompletion: (((any Error)?) -> Void)?
    func deleteToDoItem(_ item: ToDoList.ToDoItem, _ completion: @escaping ((any Error)?) -> Void) {
        self.deleteToDoItemCompletion = completion
    }
    
    var toggleToDoItemCompletion: (((any Error)?) -> Void)?
    func toggleToDoItem(_ item: inout ToDoList.ToDoItem, _ completion: @escaping ((any Error)?) -> Void) {
        item.completed.toggle()
        self.toggleToDoItemCompletion = completion
    }
    
    var searchToDoItemsCompletion: (([ToDoItem], (any Error)?) -> Void)?
    func searchToDoItems(_ searchString: String, _ completion: @escaping ([ToDoList.ToDoItem], (any Error)?) -> Void) {
        self.searchToDoItemsCompletion = completion
    }
}
