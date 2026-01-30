//
//  ToDoEditAssembly.swift
//  ToDoList
//
//  Created by Anton Kaizer on 29.01.26.
//

import SwiftUI

final class ToDoEditAssembly {
    static func build(_ container: DependencyContainer, item: ToDoItem? = nil) -> some View {
        let item = item ?? ToDoItem(id: "", title: "", completed: false, date: Date())
        let interactor = ToDoEditInteractor(item: item,
                                            toDoRepository: container.toDoRepository)
        
        let presenter = ToDoEditPresenter(interactor: interactor,
                                          router: container.router)
        
        let viewState = ToDoEditViewState(title: item.title, desc: item.description ?? "", date: item.date)
        viewState.presenter = presenter
        
        presenter.view = viewState
        
        let view = ToDoEditView(viewState: viewState)
        return view
    }
}
