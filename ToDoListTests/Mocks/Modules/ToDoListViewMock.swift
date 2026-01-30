//
//  ToDoListViewMock.swift
//  ToDoList
//
//  Created by Anton Kaizer on 30.01.26.
//

@testable import ToDoList

class ToDoListViewMock: ToDoListViewProtocol {
    func setLoading(_ loading: Bool) {
        self.loading = loading
    }
    
    func setItems(_ items: [ToDoList.ToDoItem], animated: Bool) {
        self.items = items
    }
    
    func setTasksCountPlural(_ plural: String) {
        self.tasksCountPlural = plural
    }
    
    var loading: Bool = false
    
    var items = [ToDoList.ToDoItem]()
    
    var tasksCountPlural: String = ""
    
    var searchText: String = ""
}
