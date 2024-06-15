//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 12.06.2024.
//

import Foundation
import RealmSwift
import Chameleon

final class RealmDataManager: ObservableObject {

    static let shared = RealmDataManager()
    private var selectedCategory: Category?

    private var realm: Realm?

    @Published var fetchedCategories: Results<Category>?
    @Published var fetchedTasks: Results<Tasks>?

    private init() {
        let config = Realm.Configuration(
            schemaVersion: 4,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 4 {
                    migration.enumerateObjects(ofType: Category.className()) { oldObject, newObject in newObject?["color"] = ""
                    }
                }
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

    func getSelectedCategoryColor() -> String {
        return selectedCategory?.color ?? "FFFFF"
    }

    // MARK: - Fetch
    func fetchCategories() {
        fetchedCategories = realm?.objects(Category.self)
    }

    func fetchTasks() {
        fetchedTasks = selectedCategory?.tasks.sorted(byKeyPath: "createdDate", ascending: true)
    }

    // MARK: - CRUD
    func createCategory(newCategoryName: String) {
        let newCategory = Category()
        newCategory.categoryName = newCategoryName
        newCategory.color = UIColor.randomFlat().hexValue()
        saveCategory(newCategory)
        print("✅ New category created successfully")
        fetchCategories()
    }

    func createTask(newTaskName: String) {
        let newTask = Tasks()
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
    private func saveCategory(_ newCategory: Category) {
        do {
            try realm?.write {
                realm?.add(newCategory)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }

    private func saveTask(_ newTask: Tasks) {
        do {
            try realm?.write {
                selectedCategory?.tasks.append(newTask)
            }
        } catch {
            print("Error saving new Item \(error)")
        }
    }

    private func deleteTask(_ taskToDelete: Tasks) {
        do {
            try realm?.write {
                realm?.delete(taskToDelete)
            }
        } catch {
            print("Error deleting task \(error)")
        }
    }

    private func deleteCategory(_ categoryToDelete: Category) {
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
