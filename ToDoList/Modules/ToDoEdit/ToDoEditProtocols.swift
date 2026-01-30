//
//  ToDoEditProtocols.swift
//  ToDoList
//
//  Created by Anton Kaizer on 29.01.26.
//

protocol ToDoEditInteractorProtocol: AnyObject {
    func save(_ title: String, _ description: String, _ completion: @escaping (Error?) -> Void)
}

protocol ToDoEditPresenterProtocol: AnyObject {
    func onDisappear()
}

protocol ToDoEditViewProtocol: AnyObject {
    var title: String { get set }
    var desc: String { get set }
}
