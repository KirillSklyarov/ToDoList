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
    func filterTasks(filterText: String)
    func notSearchMode()
}

final class TasksPresenter: TasksPresenterProtocol {

    weak var view: TasksVCProtocol?
    private var storage: DataStorage
    private var cancellables: Set<AnyCancellable> = []
    private let colorsArray = Constants.randomColorArray

    private var isSearch: Bool = false

    init(storage: DataStorage) {
        self.storage = storage
        dataBinding()
    }

    func filterTasks(filterText: String) {
        isSearch = true
        dataBinding()
        storage.filterTasks(filterText: filterText)
    }

    func notSearchMode() {
        isSearch = false
        dataBinding()
    }

    func dataBinding() {
        print(isSearch)
        if isSearch {
            dataBindingSearchMode()
        } else {
            dataBindingAndUpdateUI()
        }
    }

    private func dataBindingAndUpdateUI() {
        storage.$tasks
            .sink { [weak self] _ in
                self?.view?.updateUI()
            }
            .store(in: &cancellables)
    }

    private func dataBindingSearchMode() {
        storage.$filterTasks
            .sink { [weak self] _ in
                self?.view?.updateUI()
            }
            .store(in: &cancellables)
    }

    func deleteTask(indexPath: IndexPath) {
        let index = indexPath.row
        storage.deleteTask(taskIndex: index)
        view?.updateUI()
    }

    func getTasksCount() -> Int {
        if isSearch {
            return storage.filterTasks.count
        } else {
            return storage.tasks.count
        }
    }

    func getCategoryName() -> String {
        return storage.categoryName
    }

    func getTaskName(_ indexPath: IndexPath) -> String {
        if isSearch {
            return storage.filterTasks[indexPath.row]
        } else {
           return storage.tasks[indexPath.row]
        }
    }

    func getColorHex(_ indexPath: IndexPath) -> String {
        colorsArray[indexPath.row]
    }

    func plusButtonTapped() {
        view?.showAlert()
    }
}
