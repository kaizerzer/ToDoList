//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Anton Kaizer on 28.01.26.
//

import SwiftUI
import CoreData

@main
struct ToDoListApp: App {
    var dependencyContainer: DependencyContainer
    @ObservedObject var router: RouterImpl
    
    init() {
        let toDoService = ToDoServiceImpl()
        let settingsRepository = UserDefaultsSettingsRepository()
        
        let router = RouterImpl()
        
        let toDoRepository = ToDoRepositoryCoreData { error in
            if let error = error {
                router.showError(error)
            }
        }
        
        self.dependencyContainer = DependencyContainer(toDoService: toDoService,
                                                       toDoRepository: toDoRepository,
                                                       settingsRepository: settingsRepository,
                                                       router: router)
        
        router.dependencyContainer = dependencyContainer
        self.router = router
        
        UITextView.appearance().textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                self.router.navigationDestination(.ToDoList)
                    .navigationDestination(for: Module.self, destination: self.router.navigationDestination)
                    .alert(self.router.alertBody, isPresented: $router.alertPresented) {
                        if let action = self.router.alertActionHandler {
                            Button(self.router.alertAction) {
                                action()
                                self.router.alertActionHandler = nil
                                self.handleAlertQueue()
                            }
                        }
                        Button("Хорошо", role: .cancel) {
                            self.router.alertConfirmHandler?()
                            self.router.alertConfirmHandler = nil
                            self.handleAlertQueue()
                        }
                    }
            }
            
        }
    }
    func handleAlertQueue() {
        self.router.alertDismissing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.router.alertDismissing = false
        }
    }
}
