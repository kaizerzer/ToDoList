//
//  RouterImpl.swift
//  ToDoList
//
//  Created by Anton Kaizer on 30.01.26.
//

import Combine
import SwiftUI

class RouterImpl: ObservableObject, Router {
    var dependencyContainer: DependencyContainer?
    @Published var path = [Module]()
    @Published var alertBody: String = ""
    @Published var alertAction: String = ""
    @Published var alertPresented: Bool = false
    
    @Published var alertDismissing: Bool = false
    
    var alertActionHandler: (() -> Void)?
    var alertConfirmHandler: (() -> Void)?
    
    var alertQueue = [() -> Void]()
    
    var alertCancelables = Set<AnyCancellable>()
    
    init() {
        self.$alertPresented
            .combineLatest(self.$alertDismissing)
            .receive(on: DispatchQueue.main)
            .sink { presenting, dismissing in
                if !presenting && !dismissing {
                    if self.alertQueue.count > 0 {
                        self.alertQueue.removeFirst()()
                    }
                }
            }
            .store(in: &alertCancelables)
    }
    
    func enqueueAlertBlock(_ alertBlock: @escaping () -> Void) -> Void {
        DispatchQueue.main.async {
            if self.alertDismissing || self.alertPresented {
                self.alertQueue.append(alertBlock)
            } else {
                alertBlock()
            }
        }
    }
    
    func showError(_ error: Error) {
        self.enqueueAlertBlock {
            self.alertBody = error.localizedDescription
            self.alertPresented = true
        }
    }
    
    func showError(_ error: Error, confirmHandler: @escaping () -> Void) {
        self.enqueueAlertBlock {
            self.alertConfirmHandler = confirmHandler
            self.alertBody = error.localizedDescription
            self.alertPresented = true
        }
    }
    
    func showError(_ error: Error, action: String, actionHandler: @escaping () -> Void, confirmHandler: @escaping () -> Void) {
        self.enqueueAlertBlock {
            self.alertBody = error.localizedDescription
            self.alertConfirmHandler = confirmHandler
            self.alertActionHandler = actionHandler
            self.alertAction = action
            self.alertPresented = true
        }
    }
    
    func go(_ module: Module) {
        self.path.append(module)
    }
    
    @ViewBuilder
    func navigationDestination(_ module: Module) -> some View {
        switch module {
        case .ToDoList:
            ToDoListAssembly.build(dependencyContainer!)
        case .ToDoDetail(let item):
            ToDoEditAssembly.build(dependencyContainer!, item: item)
        }
    }
}
