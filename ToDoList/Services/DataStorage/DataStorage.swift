//
//  DataStorage.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import Foundation

final class DataStorage {

    static let shared = DataStorage()

    private init() { }

    var data: [DataModel] = [
        DataModel(categoryName: "Home", taskName: ["first1", "second1", "third1"]),
        DataModel(categoryName: "Work", taskName: ["first2", "second2", "third2"]),
        DataModel(categoryName: "Learn", taskName: ["first3", "second3", "third3"]),
        DataModel(categoryName: "Eat", taskName: ["first4", "second4", "third4"]),
        DataModel(categoryName: "Shopping List", taskName: ["first5", "second5", "third5"]),
    ] {
        didSet {
            tasksUpdated?()
        }
    }

    var tasks = [String]() {
        didSet {
            print("Here tasks \(tasks)")
            tasksUpdated?()
        }
    }

    var tasksUpdated: ( () -> Void )?

    var categoryName = ""

    func addNewCategory(newCategoryName: String) {
        let newCat = DataModel(categoryName: newCategoryName, taskName: [])
        data.append(newCat)
    }

    func addNewListOfTaskToStorage(_ categoryName: String) {
        getTasksName(categoryName: categoryName)
        let index = data.firstIndex { $0.categoryName == categoryName }
        if let keyIndex = index {
            data[keyIndex].taskName = tasks
        }
    }

    func addNewTask(newTaskName: String) {
        tasks.append(newTaskName)
        addNewListOfTaskToStorage(newTaskName)
    }

    func getTasksName(categoryName: String) {
        let filteredData = data.filter { $0.categoryName == categoryName }
        if let taskNames = filteredData.first?.taskName {
            tasks = taskNames
            self.categoryName = categoryName
        }
    }
}
