//
//  ToDoListInteractorTests.swift
//  ToDoList
//
//  Created by Anton Kaizer on 30.01.26.
//

import Testing
import Foundation
@testable import ToDoList

@MainActor
struct ToDoListInteractorTests {
    enum MockError: Error {
        case simpleError
    }

    let interactor: ToDoListInteractor
    let toDoServiceMock = ToDoServiceMock()
    let toDoRespositoryMock = ToDoRepositoryMock()
    let settingsRepositoryMock = SettingsRepositoryMock()
    
    let testData = [ToDoItem(id:"0", title: "data0", completed: false, date: Date()),
                    ToDoItem(id:"1", title: "data1", completed: true, date: Date()),
                    ToDoItem(id:"2", title: "data2", description: "desc", completed: false, date: Date())]
    
    init() {
        self.interactor = ToDoListInteractor(toDoService: toDoServiceMock,
                                             toDoRepository: toDoRespositoryMock,
                                             settingsRepository: settingsRepositoryMock)
    }
    
    @Test func initialLoadFirstLaunch() async {
        self.settingsRepositoryMock.firstLaunch = false
        await confirmation { confirmation in
            self.interactor.performInitialLoadingIfNeeded { error, retry in
                #expect(error == nil)
                confirmation()
            }
            #expect(self.toDoServiceMock.loadToDoItemCompletion != nil)
            self.toDoServiceMock.loadToDoItemCompletion?(testData, nil)
            #expect(self.toDoRespositoryMock.saveToDoItemsCompletion != nil)
            self.toDoRespositoryMock.saveToDoItemsCompletion?(nil)
        }
        #expect(self.settingsRepositoryMock.firstLaunch == true)
    }
    
    @Test func initialLoadFirstLaunchFail() async {
        self.settingsRepositoryMock.firstLaunch = false
        await confirmation { confirmation in
            self.interactor.performInitialLoadingIfNeeded { error, retry in
                #expect(error as? MockError == MockError.simpleError)
                confirmation()
            }
            #expect(self.toDoServiceMock.loadToDoItemCompletion != nil)
            self.toDoServiceMock.loadToDoItemCompletion?(testData, MockError.simpleError)
            #expect(self.toDoRespositoryMock.saveToDoItemsCompletion == nil)
        }
        #expect(self.settingsRepositoryMock.firstLaunch == true)
    }

    @Test func initialLoadNonFirstLaunch() async {
        self.settingsRepositoryMock.firstLaunch = true
        await confirmation { confirmation in
            self.interactor.performInitialLoadingIfNeeded { error, retry in
                #expect(error == nil)
                retry()
                confirmation()
            }
            #expect(self.toDoServiceMock.loadToDoItemCompletion == nil)
            #expect(self.toDoRespositoryMock.saveToDoItemsCompletion == nil)
        }
        #expect(self.settingsRepositoryMock.firstLaunch == true)
    }

    @Test func searchToDoItems() async {
        await confirmation { confirmation in
            self.interactor.searchToDoItems("test") { item, error in
                #expect(error == nil)
                #expect(item.count == 3)
                confirmation()
            }
            self.toDoRespositoryMock.searchToDoItemsCompletion?(self.testData, nil)
        }
        #expect(self.toDoRespositoryMock.searchToDoItemsCompletion != nil)
    }
    
    @Test func getToDoList() async {
        await confirmation { confirmation in
            self.interactor.getToDoList { item, error in
                #expect(error == nil)
                #expect(item.count == 3)
                confirmation()
            }
            self.toDoRespositoryMock.getAllToDoItemsCompletion?(self.testData, nil)
        }
        #expect(self.toDoRespositoryMock.getAllToDoItemsCompletion != nil)
    }
    
    @Test func toggleToDoItem() async {
        var testItem = self.testData[0]
        await confirmation { confirmation in
            self.interactor.toggleToDoItem(&testItem) { error in
                #expect(error == nil)
                #expect(testItem.completed == true)
                confirmation()
            }
            self.toDoRespositoryMock.saveToDoItemsCompletion?(nil)
        }
        #expect(self.toDoRespositoryMock.saveToDoItemsCompletion != nil)
    }

    @Test func deleteToDoItem() async {
        let testItem = self.testData[0]
        await confirmation { confirmation in
            self.interactor.deleteToDoItem(testItem) { error in
                #expect(error == nil)
                confirmation()
            }
            self.toDoRespositoryMock.deleteToDoItemCompletion?(nil)
        }
        #expect(self.toDoRespositoryMock.deleteToDoItemCompletion != nil)
    }
}
