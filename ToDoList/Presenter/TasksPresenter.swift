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
    func filterTasks(with filterText: String)
    func fetchTasksNotSearchMode()
}

final class TasksPresenter: TasksPresenterProtocol {

    weak var view: TasksVCProtocol?
    private var cdManager: CoreDataManager
    private var cancellables: Set<AnyCancellable> = []
    private let colorsArray = Constants.randomColorArray

    private var isSearch: Bool = false

    init(cdManager: CoreDataManager = CoreDataManager.shared) {
        self.cdManager = cdManager
        dataBindingAndUpdateUI()
    }

    func filterTasks(with filterText: String) {
        cdManager.filterTasks(with: filterText)
    }

    func fetchTasksNotSearchMode() {
        cdManager.fetchTasks()
    }

    private func dataBindingAndUpdateUI() {
        cdManager.$fetchedTasks
            .sink { [weak self] _ in
                self?.view?.updateUI()
            }
            .store(in: &cancellables)
    }

    func deleteTask(indexPath: IndexPath) {
        cdManager.deleteTask(indexPath: indexPath)
    }

    func getTasksCount() -> Int {
        return cdManager.fetchedTasks?.count ?? 0
    }

    func getCategoryName() -> String {
        return cdManager.selectedCategory!
    }

    func getTaskName(_ indexPath: IndexPath) -> String {
        cdManager.fetchedTasks![indexPath.row].taskName!
    }

    func getColorHex(_ indexPath: IndexPath) -> String {
        colorsArray[indexPath.row]
    }

    func plusButtonTapped() {
        view?.showAlert()
    }
}

