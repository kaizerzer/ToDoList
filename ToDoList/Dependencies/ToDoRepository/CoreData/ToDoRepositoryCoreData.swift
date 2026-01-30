//
//  ToDoRepositoryCoreData.swift
//  ToDoList
//
//  Created by Anton Kaizer on 28.01.26.
//
import CoreData

final class ToDoRepositoryCoreData: ToDoRepository {
    private let persistanceContainer: NSPersistentContainer
    private let backgroundContext: NSManagedObjectContext
    
    init(_ completion: @escaping (Error?) -> Void) {
        self.persistanceContainer = NSPersistentContainer(name: "ToDoList")
        self.persistanceContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            completion(error)
        })
        self.persistanceContainer.viewContext.automaticallyMergesChangesFromParent = true
        self.backgroundContext = self.persistanceContainer.newBackgroundContext()
    }
    
    private func managedToDoItem(_ item: ToDoItem, context: NSManagedObjectContext) -> ToDoItemMangedObject {
        if let url = URL(string: item.id),
           let moid = self.persistanceContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url),
            let object = context.object(with: moid) as? ToDoItemMangedObject {
            return object
        }
        return ToDoItemMangedObject(context: context)
    }
    
    func saveToDoItems(_ items: [ToDoItem], _ completion: @escaping (Error?) -> Void) {
        self.backgroundContext.perform {
            for item in items {
                let object = self.managedToDoItem(item, context: self.backgroundContext)
                object.updateValues(from: item)
            }
            
            do {
                try self.backgroundContext.save()
            } catch {
                completion(error)
            }
            completion(nil)
        }
    }
    
    func deleteToDoItem(_ item: ToDoItem, _ completion: @escaping (Error?) -> Void) {
        self.backgroundContext.perform {
            let object = self.managedToDoItem(item, context: self.backgroundContext)
            self.backgroundContext.delete(object)
            
            do {
                try self.backgroundContext.save()
            } catch {
                completion(error)
            }
            completion(nil)
        }
    }
    
    func getAllToDoItems(_ completion: @escaping ([ToDoItem], Error?) -> Void) {
        getToDoItems(predicate: nil, completion)
    }
    
    func searchToDoItems(_ text: String, _ completion: @escaping ([ToDoItem], Error?) -> Void) {
        let preidcate = NSPredicate(format: "title contains[cd] '\(text)' or desc contains[cd] '\(text)'")
        getToDoItems(predicate: preidcate, completion)
    }
    
    func getToDoItems(predicate: NSPredicate?, _ completion: @escaping ([ToDoItem], Error?) -> Void) {
        let fetchRequset = ToDoItemMangedObject.fetchRequest()
        fetchRequset.sortDescriptors = [ NSSortDescriptor(key: "date", ascending: false) ]
        fetchRequset.predicate = predicate
        self.backgroundContext.perform {
            var result = [ToDoItem]()
            do {
                let allItems = try fetchRequset.execute()
                result.append(contentsOf: allItems.map {
                    ToDoItem(managedObject: $0)
                })
            } catch {
                completion(result, error)
            }
            completion(result, nil)
        }
    }
}

extension ToDoItem {
    init(managedObject: ToDoItemMangedObject) {
        self.init(id: managedObject.objectID.uriRepresentation().absoluteString,
                  title: managedObject.title ?? "",
                  description: managedObject.desc,
                  completed: managedObject.completed,
                  date: managedObject.date ?? Date()
        )
    }
}

extension ToDoItemMangedObject {
    func updateValues(from item: ToDoItem) {
        self.title = item.title
        self.desc = item.description
        self.completed = item.completed
        self.date = item.date
    }
}
