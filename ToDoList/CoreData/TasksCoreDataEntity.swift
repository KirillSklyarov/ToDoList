//
//  TasksCoreDataEntity+CoreDataProperties.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 12.06.2024.
//
//

import Foundation
import CoreData

@objc(TasksCoreDataEntity)
public class TasksCoreDataEntity: NSManagedObject, Identifiable {

    @NSManaged public var taskName: String?
    @NSManaged public var category: CategoryCoreDataEntity?

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TasksCoreDataEntity> {
        return NSFetchRequest<TasksCoreDataEntity>(entityName: "TasksCoreDataEntity")
    }

}

