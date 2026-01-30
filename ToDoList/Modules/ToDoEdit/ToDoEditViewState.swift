//
//  ToDoEditViewState.swift
//  ToDoList
//
//  Created by Anton Kaizer on 29.01.26.
//

import Combine
import Foundation

final class ToDoEditViewState: ObservableObject, ToDoEditViewProtocol {
    @Published var title: String
    @Published var desc: String
    var date: Date
    
    var presenter: ToDoEditPresenterProtocol?
    
    init(title: String, desc: String, date: Date) {
        self.title = title
        self.desc = desc
        self.date = date
    }
    
    func onDisappear() {
        self.presenter?.onDisappear()
    }
}
