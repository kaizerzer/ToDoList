//
//  ToDoServiceMock.swift
//  ToDoList
//
//  Created by Anton Kaizer on 30.01.26.
//

@testable import ToDoList

class ToDoServiceMock: ToDoService {
    var loadToDoItemCompletion: (([ToDoList.ToDoItem], (any Error)?) -> Void)?
    func loadToDoItem(_ completion: @escaping ([ToDoList.ToDoItem], (any Error)?) -> Void) {
        self.loadToDoItemCompletion = completion
    }
}
