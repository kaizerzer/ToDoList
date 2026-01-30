//
//  ToDoListAssembly.swift
//  ToDoList
//
//  Created by Anton Kaizer on 28.01.26.
//

import SwiftUI

final class ToDoListAssembly {
    static func build(_ container: DependencyContainer) -> some View {
        let interactor = ToDoListInteractor(toDoService: container.toDoService,
                                            toDoRepository: container.toDoRepository,
                                            settingsRepository: container.settingsRepository)
        
        let presenter = ToDoListPresenter(interactor: interactor,
                                          router: container.router)
        
        let viewState = ToDoListViewState()
        viewState.presenter = presenter
        
        presenter.view = viewState
        
        let view = ToDoListView(viewState: viewState)
        return view
    }
}
