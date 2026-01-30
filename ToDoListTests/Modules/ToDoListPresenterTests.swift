//
//  ToDoListPresenterTests.swift
//  ToDoList
//
//  Created by Anton Kaizer on 30.01.26.
//

import Testing
import Foundation
@testable import ToDoList

enum MockError: Error {
    case simpleError
}

struct ToDoListPresenterTests {
    let presenter: ToDoListPresenter
    let interactorMock = ToDoListInteractorMock()
    let viewMock = ToDoListViewMock()
    let routerMock = RouterMock()
    
    let testData = [ToDoItem(id:"0", title: "data0", completed: false, date: Date()),
                    ToDoItem(id:"1", title: "data1", completed: true, date: Date()),
                    ToDoItem(id:"2", title: "data2", description: "desc", completed: false, date: Date())]
    
    init() {
        self.presenter = ToDoListPresenter(interactor: interactorMock, router: routerMock)
        self.presenter.view = viewMock
    }
    
    @Test func onAppearSuccess() {
        self.presenter.onAppear()
        #expect(self.viewMock.loading == true)
        
        self.interactorMock.performInitialLoadingIfNeededCompletion?(nil, {})
        self.interactorMock.getToDoListCompletion?(self.testData, nil)
        
        #expect(self.routerMock.currentError == nil)
        #expect(self.viewMock.loading == false)
        #expect(self.viewMock.items.count == 3)
    }
    
    @Test func onAppearLoadingFailure() {
        self.presenter.onAppear()
        #expect(self.viewMock.loading == true)
        
        self.interactorMock.performInitialLoadingIfNeededCompletion?(MockError.simpleError, {})
        
        #expect(self.routerMock.currentError as? MockError == MockError.simpleError)
        #expect(self.viewMock.loading == true)
        #expect(self.viewMock.items.count == 0)
        
        self.routerMock.confirmHandler?()
        self.interactorMock.getToDoListCompletion?(self.testData, nil)
        
        #expect(self.viewMock.loading == false)
        #expect(self.viewMock.items.count == 3)
    }
    
    @Test func onAppearDatabaseFailure() {
        self.presenter.onAppear()
        #expect(self.viewMock.loading == true)
        
        self.interactorMock.performInitialLoadingIfNeededCompletion?(nil, {})
        self.interactorMock.getToDoListCompletion?([], MockError.simpleError)
        
        #expect(self.routerMock.currentError as? MockError == MockError.simpleError)
        #expect(self.viewMock.loading == false)
        #expect(self.viewMock.items.count == 0)
    }
    
    @Test func reloadListSearchText() {
        self.presenter.reloadList("test")
        self.interactorMock.searchToDoItemsCompletion?(self.testData, nil)
        
        #expect(self.routerMock.currentError == nil)
        #expect(self.viewMock.items.count == 3)
        #expect(self.viewMock.tasksCountPlural == "2 задачи")
    }
    
    @Test func reloadListNoSearchText() {
        self.presenter.reloadList(nil)
        self.interactorMock.getToDoListCompletion?(self.testData, nil)
        
        #expect(self.routerMock.currentError == nil)
        #expect(self.viewMock.items.count == 3)
        #expect(self.viewMock.tasksCountPlural == "2 задачи")
    }
    
    @Test func reloadListError() {
        self.presenter.reloadList(nil)
        self.interactorMock.getToDoListCompletion?([], MockError.simpleError)
        
        #expect(self.routerMock.currentError as? MockError == MockError.simpleError)
        #expect(self.viewMock.items.count == 0)
    }
    
    @Test func itemToggled() {
        var testItem = self.testData[0]
        
        self.presenter.itemToggled(&testItem)
        self.interactorMock.toggleToDoItemCompletion?(nil)
        
        #expect(self.routerMock.currentError == nil)
        #expect(testItem.completed == true)
    }
    
    @Test func itemToggledError() {
        var testItem = self.testData[0]
        
        self.presenter.itemToggled(&testItem)
        self.interactorMock.toggleToDoItemCompletion?(MockError.simpleError)
        
        #expect(self.routerMock.currentError as? MockError == MockError.simpleError)
    }
    
    @Test func searchTextDidChange() {
        self.presenter.searchTextDidChange("test")
        self.interactorMock.searchToDoItemsCompletion?(self.testData, nil)
        
        #expect(self.routerMock.currentError == nil)
        #expect(self.viewMock.items.count == 3)
        #expect(self.viewMock.tasksCountPlural == "2 задачи")
    }
    
    @Test func deleteItemPressed() {
        let testItem = self.testData[0]
        self.presenter.deleteItemPressed(testItem)
        self.interactorMock.deleteToDoItemCompletion?(nil)
        
        #expect(self.routerMock.currentError == nil)
    }
    
    @Test func deleteItemPressedError() {
        let testItem = self.testData[0]
        self.presenter.deleteItemPressed(testItem)
        self.interactorMock.deleteToDoItemCompletion?(MockError.simpleError)
        
        #expect(self.routerMock.currentError as? MockError == MockError.simpleError)
    }
    
    @Test func editItem() {
        let testItem = self.testData[0]
        self.presenter.editItem(testItem)
        
        #expect(self.routerMock.currentError == nil)
        #expect(self.routerMock.curentModule == .ToDoDetail(toDo: testItem))
    }
    
    @Test func createItem() {
        self.presenter.createItem()
        
        #expect(self.routerMock.currentError == nil)
        #expect(self.routerMock.curentModule == .ToDoDetail(toDo: nil))
    }
    
    @Test func updateItems() {
        self.presenter.updateItems(self.testData)
        
        #expect(self.routerMock.currentError == nil)
        #expect(self.viewMock.items.count == 3)
        #expect(self.viewMock.tasksCountPlural == "2 задачи")
    }
    
    @Test func updateTaskCountPlural() {
        self.presenter.updateTaskCountPlural(self.testData)
        
        #expect(self.routerMock.currentError == nil)
        #expect(self.viewMock.tasksCountPlural == "2 задачи")
    }
    
    @Test func tasksCountPlural() {
        #expect(self.presenter.tasksCountPlural(0) == "0 задач")
        #expect(self.presenter.tasksCountPlural(1) == "1 задача")
        #expect(self.presenter.tasksCountPlural(2) == "2 задачи")
        #expect(self.presenter.tasksCountPlural(5) == "5 задач")
        #expect(self.presenter.tasksCountPlural(12) == "12 задач")
        #expect(self.presenter.tasksCountPlural(121) == "121 задача")
        #expect(self.presenter.tasksCountPlural(124) == "124 задачи")
        #expect(self.presenter.tasksCountPlural(126) == "126 задач")
    }
}
