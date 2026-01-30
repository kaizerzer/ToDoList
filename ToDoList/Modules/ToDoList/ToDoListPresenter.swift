//
//  ToDoPresenter.swift
//  ToDoList
//
//  Created by Anton Kaizer on 28.01.26.
//

final class ToDoListPresenter: ToDoListPresenterProtocol {
    var interactor: ToDoListInteractorProtocol
    weak var view: ToDoListViewProtocol?
    var router: Router
    
    
    init(interactor: ToDoListInteractorProtocol, router: Router) {
        self.interactor = interactor
        self.router = router
    }
    
    func onAppear() {
        self.view?.setLoading(true)
        self.interactor.performInitialLoadingIfNeeded { [weak self] error, retry in
            if let error = error {
                self?.router.showError(error, action: "Повторить", actionHandler: retry) {
                    self?.view?.setLoading(false)
                    self?.reloadList(nil)
                }
                return
            }
            
            self?.view?.setLoading(false)
            self?.reloadList(nil)
        }
    }
    
    func reloadList(_ searchText: String?) {
        let searchText = searchText ?? self.view?.searchText
        let completion: ([ToDoItem], Error?) -> Void = { [weak self] items, error in
            if let error = error {
                self?.router.showError(error)
                return
            }
            self?.updateItems(items)
        }
        
        if let searchText = searchText, !searchText.isEmpty {
            self.interactor.searchToDoItems(searchText, completion)
        } else {
            self.interactor.getToDoList(completion)
        }
    }
    
    func itemToggled(_ task: inout ToDoItem) {
        self.interactor.toggleToDoItem(&task) { [weak self] error in
            if let error = error {
                self?.router.showError(error)
                return
            }
            self?.updateTaskCountPlural()
        }
    }
    
    func searchTextDidChange(_ searchText: String) {
        self.reloadList(searchText)
    }
    
    func deleteItemPressed(_ item: ToDoItem) {
        self.interactor.deleteToDoItem(item) { [weak self] error in
            if let error = error {
                self?.router.showError(error)
                return
            }
            self?.reloadList(nil)
        }
    }
    
    func editItem(_ item: ToDoItem) {
        self.router.go(.ToDoDetail(toDo: item))
    }
    
    func createItem() {
        self.router.go(.ToDoDetail(toDo: nil))
    }
    
    func updateItems(_ items: [ToDoItem]) {
        self.view?.setItems(items, animated: true)
        self.updateTaskCountPlural(items)
    }
    
    func updateTaskCountPlural(_ items: [ToDoItem]? = nil) {
        guard let view = self.view else { return }
        let items = items ?? view.items
        view.setTasksCountPlural(self.tasksCountPlural(items.count { !$0.completed }))
    }
    
    func tasksCountPlural(_ count: Int) -> String {
        let lastDigit = count % 10
        let lastTwoDigits = count % 100
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 14 {
            return "\(count) задач"
        }
        
        switch lastDigit {
        case 1:
            return "\(count) задача"
        case 2, 3, 4:
            return "\(count) задачи"
        default:
            return "\(count) задач"
        }
    }
}
