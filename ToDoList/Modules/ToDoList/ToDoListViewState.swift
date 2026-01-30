//
//  ToDoListViewState.swift
//  ToDoList
//
//  Created by Anton Kaizer on 29.01.26.
//

import Combine
import SwiftUI

final class ToDoListViewState: ObservableObject, ToDoListViewProtocol {
    @Published var loading = false
    @Published var items = [ToDoItem]()
    
    @Published var tasksCountPlural: String = ""
    
    @Published var searchText: String = ""
    
    var presenter: ToDoListPresenterProtocol?
    
    private var cancelables = Set<AnyCancellable>()
    
    func onAppear() {
        self.presenter?.onAppear()
    }
    
    func itemToggled(_ item: inout ToDoItem) {
        self.presenter?.itemToggled(&item)
    }
    
    func deleteItem(_ item: ToDoItem) {
        self.presenter?.deleteItemPressed(item)
    }
    
    func editItem(_ item: ToDoItem) {
        self.presenter?.editItem(item)
    }
    
    func createItem() {
        self.presenter?.createItem()
    }
    
    init() {
        $searchText
            .removeDuplicates()
            .sink { [weak self] value in
                self?.presenter?.searchTextDidChange(value)
            }
            .store(in: &cancelables)
    }
    
    var itemsChangeAnimation: (() -> Void) -> Void {
        get {
            { block in
                withAnimation(.linear(duration: 0.1), block)
            }
        }
    }
}
