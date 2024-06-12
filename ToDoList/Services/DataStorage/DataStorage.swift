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

    @Published var data: [DataModel] = [
        DataModel(categoryName: "Home", taskName: ["first1", "second1", "third1"]),
        DataModel(categoryName: "Work", taskName: ["first2", "second2", "third2"]),
        DataModel(categoryName: "Learn", taskName: ["first3", "second3", "third3"]),
        DataModel(categoryName: "Eat", taskName: ["first4", "second4", "third4"]),
        DataModel(categoryName: "Shopping List", taskName: ["first5", "second5", "third5"]),
    ]

    @Published var tasks = [String]()

    var categoryName = ""

    func addNewCategory(newCategoryName: String) {
        let newCat = DataModel(categoryName: newCategoryName, taskName: [])
        data.append(newCat)
        print("data \(data)")
    }

    func addNewListOfTaskToStorage() {
        let index = data.firstIndex { $0.categoryName == categoryName }
        if let keyIndex = index {
            data[keyIndex].taskName = tasks
        }
    }

    func addNewTask(newTaskName: String) {
        tasks.append(newTaskName)
        addNewListOfTaskToStorage()
    }

    func getTasksName(categoryName: String) {
        let filteredData = data.filter { $0.categoryName == categoryName }
        if let taskNames = filteredData.first?.taskName {
            tasks = taskNames
            self.categoryName = categoryName
        }
    }
}
