//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 12.06.2024.
//

import Foundation
import CoreData

final class CoreDataManager: NSObject, ObservableObject {

    static let shared = CoreDataManager()

    var selectedCategory: String?

    @Published var fetchedCategories: [CategoryCD]?
    @Published var fetchedTasks: [TasksCD]?

    private override init() { }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("🔴 Unresolved error \(error), \(error.userInfo)")
            } else {
                print("✅ CoreDate upload successfully")
                //                print("\(String(describing: storeDescription.url))")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func getSelectedCategory(_ selectedCat: String) {
        selectedCategory = selectedCat
    }

    // MARK: - Fetch
    func fetchCategories() {
        let request = CategoryCD.fetchRequest()
        do {
            fetchedCategories = try context.fetch(request)
            print("✅ Categories upload successfully")
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetchTasks() {
        let request = CategoryCD.fetchRequest()
        request.predicate = NSPredicate(format: "categoryName = %@", selectedCategory!)

        do {
            let data = try context.fetch(request)
            let wr = data.first!.tasks as? Set<TasksCD>
            fetchedTasks = Array(wr!).sorted(by: { $0.taskName! < $1.taskName! })
            print("✅ Tasks upload successfully")

        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - CRUD
    func createCategory(newCategoryName: String) {
        let newCategory = CategoryCD(context: context)
        newCategory.categoryName = newCategoryName
        saveContext()
        print("New category created successfully ✅")
        fetchCategories()
    }

    func deleteCategoryNEW(indexPath: IndexPath) {
        let categoryToRemove = fetchedCategories![indexPath.row]
        context.delete(categoryToRemove)
        saveContext()
        fetchedCategories?.remove(at: indexPath.row)
    }

    func createTask(newTaskName: String) {
        let request = CategoryCD.fetchRequest()
        request.predicate = NSPredicate(format: "categoryName = %@", selectedCategory!)

        do {
            let result = try context.fetch(request)
            let category = result.first

            let newTask = TasksCD(context: context)
            newTask.taskName = newTaskName

            category!.addToTasks(newTask)
            saveContext()
            print("✅ New task added successfully")
            fetchTasks()
        } catch {
            print("🔴 \(error.localizedDescription)")
        }
    }

    func deleteTask(indexPath: IndexPath) {
        let taskToRemove = fetchedTasks![indexPath.row]
        context.delete(taskToRemove)
        saveContext()
        fetchedTasks?.remove(at: indexPath.row)
    }

    // MARK: - Save
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

    // MARK: - Filter
    func filterTasks(with filter: String) {
        let array = fetchedTasks
        fetchedTasks = array!.filter { $0.taskName?.contains(filter) ?? false }
    }
}
