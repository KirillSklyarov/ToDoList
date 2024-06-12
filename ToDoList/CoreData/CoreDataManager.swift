//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 12.06.2024.
//

import Foundation
import CoreData

final class CoreDataManager: NSObject {

    static let shared = CoreDataManager()

    private let storage = DataStorage.shared

    var newData = [DataModel]()

    var data: [CategoryCoreDataEntity]?

    private override init() { }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("🔴 Unresolved error \(error), \(error.userInfo)")
            } else {
                print("✅ CoreDate upload successfully")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - CRUD
    func fetchData() {
        let request = CategoryCoreDataEntity.fetchRequest()
        do {
            data = try context.fetch(request)
            print("data \(data!)")
            CDCategoryMapping(coreData: data)
        } catch {
            print(error.localizedDescription)
        }
    }

    func CDCategoryMapping(coreData: [CategoryCoreDataEntity]?) {
        guard let coreData else { print("Hmmm"); return }
        coreData.forEach { element in
            let categoryName = element.categoryName
            let tasksToString = element.tasks?.compactMap { $0 as? String }
            let data = DataModel(categoryName: categoryName!, taskName: tasksToString!)
            newData.append(data)
        }
        print("newData \(newData)")
    }

    func addCategory(newCategoryName: String) {
        let newCategory = CategoryCoreDataEntity(context: context)
        newCategory.categoryName = newCategoryName
        saveContext()
        print("New category created successfully ✅")
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
