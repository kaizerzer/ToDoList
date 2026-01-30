//
//  ToDoEditInteractor.swift
//  ToDoList
//
//  Created by Anton Kaizer on 29.01.26.
//

final class ToDoEditInteractor: ToDoEditInteractorProtocol {
    var item: ToDoItem
    let toDoRepository: ToDoRepository
    
    init(item: ToDoItem, toDoRepository: ToDoRepository) {
        self.item = item
        self.toDoRepository = toDoRepository
    }
    
    func save(_ title: String, _ description: String, _ completion: @escaping (Error?) -> Void) {
        guard title.count > 0 else {
            completion(nil)
            return
        }
        self.item.title = title
        self.item.description = description.count > 0 ? description : nil
        self.toDoRepository.saveToDoItems([item], completion)
    }
}
