//
//  TasksPresenter.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import Foundation

protocol TasksPresenterProtocol: AnyObject {
    func plusButtonTapped()
    func getTasksCount() -> Int
    func getTaskName(_ indexPath: IndexPath) -> String
    func getColorHex(_ indexPath: IndexPath) -> String
    func getCategoryName() -> String
}

final class TasksPresenter: TasksPresenterProtocol {
    
    weak var view: TasksVCProtocol?
    var storage: DataStorage

    init(storage: DataStorage) {
        self.storage = storage
        updateUI()
    }

    private var newCat = ""
    let colorsArray = Constants.randomColorArray

    private func updateUI() {
        storage.tasksUpdated = { [weak self] in
            self?.view?.updateUI()
        }
    }

    func getTasksCount() -> Int {
        return storage.tasks.count
    }

    func getCategoryName() -> String {
        return storage.categoryName
    }

    func getTaskName(_ indexPath: IndexPath) -> String {
        storage.tasks[indexPath.row]
    }

    func getColorHex(_ indexPath: IndexPath) -> String {
        colorsArray[indexPath.row]
    }

    func plusButtonTapped() {
        view?.showAlert()
    }

//    func addNewTask(newTaskName: String) {
//        storage.addNewListOfTaskToStorage(newTaskName)
//        updateData()
//    }

//    func updateData() {
//         getTasksName(categoryName: categoryName)
//    }
}
