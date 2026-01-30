//
//  ToDoEditInteractorTests.swift
//  ToDoList
//
//  Created by Anton Kaizer on 30.01.26.
//

import Testing
import Foundation
@testable import ToDoList

@MainActor
struct ToDoEditInteractorTests {
    enum MockError: Error {
        case simpleError
    }
    
    let toDoRespositoryMock = ToDoRepositoryMock()
    
    let testData = ToDoItem(id:"0", title: "data0", completed: false, date: Date())
    
    @Test func save() async {
        let interactor = ToDoEditInteractor(item: testData, toDoRepository: toDoRespositoryMock)
        await confirmation { confirmation in
            interactor.save("test", "test") { error in
                #expect(error == nil)
                confirmation()
            }
            self.toDoRespositoryMock.saveToDoItemsCompletion?(nil)
        }
        #expect(self.toDoRespositoryMock.saveToDoItemsCompletion != nil)
    }
    
    @Test func saveError() async {
        let interactor = ToDoEditInteractor(item: testData, toDoRepository: toDoRespositoryMock)
        await confirmation { confirmation in
            interactor.save("test", "test") { error in
                #expect(error as? MockError == MockError.simpleError)
                confirmation()
            }
            self.toDoRespositoryMock.saveToDoItemsCompletion?(MockError.simpleError)
        }
        #expect(self.toDoRespositoryMock.saveToDoItemsCompletion != nil)
    }
    
    @Test func notSaveEmpty() async {
        let interactor = ToDoEditInteractor(item: testData, toDoRepository: toDoRespositoryMock)
        await confirmation { confirmation in
            interactor.save("", "test") { error in
                #expect(error == nil)
                confirmation()
            }
        }
        #expect(self.toDoRespositoryMock.saveToDoItemsCompletion == nil)
    }
}
