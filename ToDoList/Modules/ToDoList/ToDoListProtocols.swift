//
//  ToDoListProtocols.swift
//  ToDoList
//
//  Created by Anton Kaizer on 28.01.26.
//

protocol ToDoListInteractorProtocol: AnyObject {
    func performInitialLoadingIfNeeded(_ completion: @escaping (Error?, @escaping () -> Void) -> Void)
    func getToDoList(_ completion: @escaping ([ToDoItem], Error?) -> Void)
    func deleteToDoItem(_ item: ToDoItem, _ completion: @escaping (Error?) -> Void)
    func toggleToDoItem(_ item: inout ToDoItem, _ completion: @escaping (Error?) -> Void)
    func searchToDoItems(_ searchString: String, _ completion: @escaping ([ToDoItem], Error?) -> Void)
}

protocol ToDoListPresenterProtocol: AnyObject {
    func onAppear()
    func itemToggled(_ task: inout ToDoItem)
    
    func searchTextDidChange(_ searchText: String)
    func deleteItemPressed(_ item: ToDoItem)
    func editItem(_ item: ToDoItem)
    func createItem()
}

protocol ToDoListViewProtocol: AnyObject {
    var loading: Bool { get set }
    var items: [ToDoItem] { get set }
    var tasksCountPlural: String { get set }
    var searchText: String { get }
    
    var itemsChangeAnimation: (() -> Void) -> Void { get }
}
