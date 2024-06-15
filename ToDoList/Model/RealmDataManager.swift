//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 12.06.2024.
//

import Foundation
import RealmSwift

final class RealmDataManager: ObservableObject {

    static let shared = RealmDataManager()
    private var selectedCategory: CategoryCD?

    private var realm: Realm?

    @Published var fetchedCategories: Results<CategoryCD>?
    @Published var fetchedTasks: Results<TasksCD>?

    private init() {
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {  }
            }
        )
        Realm.Configuration.defaultConfiguration = config

        do {
            realm = try Realm()
        } catch {
            print("Error opening realm \(error)")
        }
    }

    func setSelectedCategory(indexPath: IndexPath) {
        selectedCategory = fetchedCategories?[indexPath.row]
    }

    func getSelectedCategoryFromCDM() -> String {
        return selectedCategory?.categoryName ?? "Ooops"
    }

    // MARK: - Fetch
    func fetchCategories() {
        fetchedCategories = realm?.objects(CategoryCD.self)
    }

    func fetchTasks() {
        fetchedTasks = selectedCategory?.tasks.sorted(byKeyPath: "createdDate", ascending: true)
    }

    // MARK: - CRUD
    func createCategory(newCategoryName: String) {
        let newCategory = CategoryCD()
        newCategory.categoryName = newCategoryName
        saveCategory(newCategory)
        print("✅ New category created successfully")
        fetchCategories()
    }

    func createTask(newTaskName: String) {
        let newTask = TasksCD()
        newTask.taskName = newTaskName
        saveTask(newTask)
        print("✅ New task created successfully")
        fetchTasks()
    }

    func deleteTask(indexPath: IndexPath) {
        guard let taskToRemove = fetchedTasks?[indexPath.row] else { print("123"); return}
        deleteTask(taskToRemove)
        fetchTasks()
        print("✅ Task deleted successfully")
    }

    func deleteCategory(indexPath: IndexPath) {
        guard let categoryToRemove = fetchedCategories?[indexPath.row] else { print("123"); return}
        deleteCategory(categoryToRemove)
        fetchCategories()
        print("✅ Category deleted successfully")
    }

    // MARK: - Private methods
    private func saveCategory(_ newCategory: CategoryCD) {
        do {
            try realm?.write {
                realm?.add(newCategory)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }

    private func saveTask(_ newTask: TasksCD) {
        do {
            try realm?.write {
                selectedCategory?.tasks.append(newTask)
            }
        } catch {
            print("Error saving new Item \(error)")
        }
    }

    private func deleteTask(_ taskToDelete: TasksCD) {
        do {
            try realm?.write {
                realm?.delete(taskToDelete)
            }
        } catch {
            print("Error deleting task \(error)")
        }
    }

    private func deleteCategory(_ categoryToDelete: CategoryCD) {
        do {
            try realm?.write {
                realm?.delete(categoryToDelete)
            }
        } catch {
            print("Error deleting category \(error)")
        }
    }

    // MARK: - Filter
    func filterTasks(with filter: String) {
        fetchedTasks = fetchedTasks?.filter("taskName CONTAINS %@", filter )
    }
}
