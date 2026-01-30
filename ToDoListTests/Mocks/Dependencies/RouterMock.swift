//
//  RouterMock.swift
//  ToDoList
//
//  Created by Anton Kaizer on 30.01.26.
//

@testable import ToDoList

class RouterMock: Router {
    var curentModule: Module?
    var currentError: (any Error)?
    var currentAction: String?
    var confirmHandler: (()->Void)?
    var actionHandler: (()->Void)?
    
    func showError(_ error: any Error) {
        self.currentError = error
        self.currentAction = nil
    }
    
    func showError(_ error: any Error, confirmHandler: @escaping () -> Void) {
        self.currentError = error
        self.currentAction = nil
    }
    
    func showError(_ error: any Error, action: String, actionHandler: @escaping () -> Void, confirmHandler: @escaping () -> Void) {
        self.currentError = error
        self.currentAction = action
        self.confirmHandler = confirmHandler
        self.actionHandler = actionHandler
    }
    
    func go(_ module: ToDoList.Module) {
        self.curentModule = module
    }
}
