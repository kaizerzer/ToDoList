//
//  ToDoItemMangedObject+CoreDataProperties.swift
//  ToDoList
//
//  Created by Anton Kaizer on 29.01.26.
//
//

public import Foundation
public import CoreData


public typealias ToDoItemMangedObjectCoreDataPropertiesSet = NSSet

extension ToDoItemMangedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItemMangedObject> {
        return NSFetchRequest<ToDoItemMangedObject>(entityName: "ToDoItemMangedObject")
    }

    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var completed: Bool
    @NSManaged public var date: Date?

}

extension ToDoItemMangedObject : Identifiable {

}
