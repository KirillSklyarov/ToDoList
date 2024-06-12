//
//  DataStorage.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import Foundation
import Combine

final class DataStorage: ObservableObject {

    static let shared = DataStorage()

    private init() { }

    @Published var data: [DataModel] = []
    @Published var tasks = [String]()

    var categoryName = ""

    func addNewTask(newTaskName: String) {
        CoreDataManager.shared.addNewTask(categoryName: categoryName, newTask: newTaskName)
        tasks.append(newTaskName)
    }

    func deleteTask(taskIndex: Int) {
        let taskToRemove = tasks[taskIndex]
        tasks.remove(at: taskIndex)
        CoreDataManager.shared.removeTask(categoryName: categoryName, task: taskToRemove) 
//        addNewTask(categoryName: categoryName, newTask: newTaskName)

    }

    func getTasksName(categoryName: String) {
        let filteredData = data.filter { $0.categoryName == categoryName }
        if let taskNames = filteredData.first?.taskName {
            tasks = taskNames
            self.categoryName = categoryName
        }
    }
}
