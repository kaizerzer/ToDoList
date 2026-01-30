//
//  ToDoEditInteractorMock.swift
//  ToDoList
//
//  Created by Anton Kaizer on 30.01.26.
//

@testable import ToDoList

class ToDoEditInteractorMock: ToDoEditInteractorProtocol {
    var saveCompletion: (((any Error)?) -> Void)?
    func save(_ title: String, _ description: String, _ completion: @escaping ((any Error)?) -> Void) {
        self.saveCompletion = completion
    }
}
