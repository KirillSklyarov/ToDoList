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

    var fetchedData: [CategoryCoreDataEntity]?

    private override init() { }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("🔴 Unresolved error \(error), \(error.userInfo)")
            } else {
                print("✅ CoreDate upload successfully \(String(describing: storeDescription.url))")
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
            fetchedData = try context.fetch(request)
            CDCategoryMapping(coreData: fetchedData)
        } catch {
            print(error.localizedDescription)
        }
    }

    func CDCategoryMapping(coreData: [CategoryCoreDataEntity]?) {
        guard let coreData else { print("Hmmm"); return }
        newData = []
        var taskNames = [String]()
        coreData.forEach { element in
            guard let categoryName = element.categoryName,
                  let tasks = element.tasks as? Set<TasksCoreDataEntity> else { print("123"); return }
            taskNames = tasks.compactMap { $0.taskName }
            let data = DataModel(categoryName: categoryName, taskName: taskNames)
            newData.append(data)
        }
        sendFetchedDataToStorage()
    }

    func sendFetchedDataToStorage() {
        storage.data = newData
    }

    func addCategory(newCategoryName: String) {
        let newCategory = CategoryCoreDataEntity(context: context)
        newCategory.categoryName = newCategoryName
        saveContext()
        print("New category created successfully ✅")
        fetchData()
    }

    func addNewTask(categoryName: String, newTask: String) {
        print("categoryName \(categoryName)")
        let request = CategoryCoreDataEntity.fetchRequest()
        request.predicate = NSPredicate(format: "categoryName = %@", categoryName)

        do {
            let result = try context.fetch(request)
            print("result \(result)")
            let keyCategory = result.first
            let newTaskToAdd = TasksCoreDataEntity(context: context)
            newTaskToAdd.taskName = newTask
            keyCategory?.addToTasks(newTaskToAdd)
            saveContext()
            print("New task added successfully ✅")
        } catch {
            print("🔴 \(error.localizedDescription)")
        }
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
