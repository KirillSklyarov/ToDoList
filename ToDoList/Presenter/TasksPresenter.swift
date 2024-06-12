//
//  TasksPresenter.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import Foundation
import Combine

protocol TasksPresenterProtocol: AnyObject {
    func plusButtonTapped()
    func getTasksCount() -> Int
    func getTaskName(_ indexPath: IndexPath) -> String
    func getColorHex(_ indexPath: IndexPath) -> String
    func getCategoryName() -> String
    func deleteTask(indexPath: IndexPath)
}

final class TasksPresenter: TasksPresenterProtocol {

    weak var view: TasksVCProtocol?
    private var storage: DataStorage
    private var cancellables: Set<AnyCancellable> = []
    private var newCat = ""
    private let colorsArray = Constants.randomColorArray

    init(storage: DataStorage) {
        self.storage = storage
        dataBindingAndUpdateUI()
    }

    private func dataBindingAndUpdateUI() {
        storage.$tasks
            .sink { [weak self] _ in
                self?.view?.updateUI()
            }
            .store(in: &cancellables)
        }

    func deleteTask(indexPath: IndexPath) {
        let index = indexPath.row
//        print("Delete")
        storage.deleteTask(taskIndex: index)
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
}
