//
//  CategoryCoreDataEntity+CoreDataProperties.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 12.06.2024.
//
//

import Foundation
import CoreData

@objc(CategoryCoreDataEntity)
public class CategoryCoreDataEntity: NSManagedObject, Identifiable {

    @NSManaged public var categoryName: String?
    @NSManaged public var tasks: NSSet?

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryCoreDataEntity> {
        return NSFetchRequest<CategoryCoreDataEntity>(entityName: "CategoryCoreDataEntity")
    }

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: TasksCoreDataEntity)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: TasksCoreDataEntity)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
