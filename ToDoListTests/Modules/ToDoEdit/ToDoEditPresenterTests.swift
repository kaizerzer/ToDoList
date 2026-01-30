//
//  ToDoEditPresenterTests.swift
//  ToDoList
//
//  Created by Anton Kaizer on 30.01.26.
//

import Testing
import Foundation
@testable import ToDoList

struct ToDoEditPresenterTests {
    enum MockError: Error {
        case simpleError
    }

    let presenter: ToDoEditPresenter
    let interactorMock = ToDoEditInteractorMock()
    let viewMock = ToDoEditViewMock()
    let routerMock = RouterMock()
    
    init() {
        self.presenter = ToDoEditPresenter(interactor: interactorMock, router: routerMock)
        self.presenter.view = viewMock
    }
    
    @Test func onDisappearSaveSuccess() {
        self.presenter.onDisappear()
        #expect(self.interactorMock.saveCompletion != nil)
        self.interactorMock.saveCompletion?(nil)
        #expect(self.routerMock.currentError == nil)
    }
    
    @Test func onDisappearSaveFailure() {
        self.presenter.onDisappear()
        #expect(self.interactorMock.saveCompletion != nil)
        self.interactorMock.saveCompletion?(MockError.simpleError)
        #expect(self.routerMock.currentError as? MockError == MockError.simpleError)
    }
}
