//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created by Anton Kaizer on 29.01.26.
//

final class ToDoListInteractor: ToDoListInteractorProtocol {
    let toDoService: ToDoService
    let toDoRepository: ToDoRepository
    let settingsRepository: SettingsRepository
    
    init(toDoService: ToDoService,
         toDoRepository: ToDoRepository,
         settingsRepository: SettingsRepository) {
        self.toDoService = toDoService
        self.toDoRepository = toDoRepository
        self.settingsRepository = settingsRepository
    }
    
    func performInitialLoadingIfNeeded(_ completion: @escaping (Error?, @escaping () -> Void) -> Void) {
        if !self.settingsRepository.firstLaunch {
            var loadData: (() -> Void)!
            loadData = { [weak self] in
                self?.toDoService.loadToDoItem { items, error in
                    if let error = error {
                        completion(error, loadData)
                        return
                    }
                    self?.toDoRepository.saveToDoItems(items) { error in
                        completion(error, loadData)
                    }
                }
            }
            loadData()
            self.settingsRepository.firstLaunch = true
        } else {
            completion(nil, {})
        }
    }
    
    func searchToDoItems(_ searchString: String, _ completion: @escaping ([ToDoItem], Error?) -> Void) {
        self.toDoRepository.searchToDoItems(searchString, completion)
    }
    
    func getToDoList(_ completion: @escaping ([ToDoItem], Error?) -> Void) {
        self.toDoRepository.getAllToDoItems(completion)
    }
    
    func toggleToDoItem(_ item: inout ToDoItem, _ completion: @escaping (Error?) -> Void) {
        item.completed.toggle()
        self.toDoRepository.saveToDoItems([item], completion)
    }
    
    func deleteToDoItem(_ item: ToDoItem, _ completion: @escaping (Error?) -> Void) {
        self.toDoRepository.deleteToDoItem(item, completion)
    }
}
