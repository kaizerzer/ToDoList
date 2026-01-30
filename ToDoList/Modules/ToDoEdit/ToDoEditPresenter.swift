//
//  ToDoEditPresenter.swift
//  ToDoList
//
//  Created by Anton Kaizer on 29.01.26.
//

final class ToDoEditPresenter: ToDoEditPresenterProtocol {
    let interactor: ToDoEditInteractorProtocol
    var router: any Router
    weak var view: ToDoEditViewProtocol?
    
    func onDisappear() {
        if let view = self.view {
            let router = self.router
            self.interactor.save(view.title, view.desc) { error in
                if let error = error {
                    router.showError(error)
                    return
                }
            }
        }
    }
    
    init(interactor: ToDoEditInteractorProtocol, router: any Router) {
        self.interactor = interactor
        self.router = router
    }
}
