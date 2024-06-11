//
//  TasksPresenter.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import Foundation

protocol TasksPresenterProtocol: AnyObject {
    func plusButtonTapped()
    func addNewTask(newTaskName: String)
    func updateData()
    func getTasksCount() -> Int
    func getTaskName(_ indexPath: IndexPath) -> String
    func getColorHex(_ indexPath: IndexPath) -> String
    func getTasksName(categoryName: String)
}

final class TasksPresenter: TasksPresenterProtocol {

    weak var view: TasksVCProtocol?

    private var data = [DataModel]()
    private var newCat = ""
    let colorsArray = Constants.randomColorArray
    var tasks = [String]()
    var categoryName = ""

    func getTasksCount() -> Int {
        tasks.count
    }

    func getTaskName(_ indexPath: IndexPath) -> String {
        tasks[indexPath.row]
    }

    func getColorHex(_ indexPath: IndexPath) -> String {
        colorsArray[indexPath.row]
    }

    func plusButtonTapped() {
        view?.showAlert()
    }

    func addNewTask(newTaskName: String) {
        tasks.append(newTaskName)
        addNewListOfTaskToStorage()
        updateData()
    }

    private func addNewListOfTaskToStorage() {
        let index = MockData.data.firstIndex { $0.categoryName == categoryName }
        if let keyIndex = index {
            MockData.data[keyIndex].taskName = tasks
        }
    }

    func updateData() {
        getTasksName(categoryName: categoryName)
    }


    func getTasksName(categoryName: String) {
        let data = MockData.data
        let filteredData = data.filter { $0.categoryName == categoryName }
        if let taskNames = filteredData.first?.taskName {
            tasks = taskNames
            self.categoryName = categoryName
        }
    }
}


