//
//  Router.swift
//  ToDoList
//
//  Created by Anton Kaizer on 29.01.26.
//

protocol Router {
    func showError(_ error: Error)
    func showError(_ error: Error, confirmHandler: @escaping () -> Void)
    func showError(_ error: Error, action: String, actionHandler: @escaping () -> Void, confirmHandler: @escaping () -> Void)
    func go(_ module: Module)
}
