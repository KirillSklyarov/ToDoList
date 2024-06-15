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
    func getTaskDate(_ indexPath: IndexPath) -> Date
}

final class TasksPresenter: TasksPresenterProtocol {

    // MARK: - Properties
    weak var view: TasksVCProtocol?
    private var realmDataManager: RealmDataManager
    private var cancellables: Set<AnyCancellable> = []
    private let colorsArray = Constants.randomColorArray

    // MARK: - Init
    init(realmDataManager: RealmDataManager = RealmDataManager.shared) {
        self.realmDataManager = realmDataManager
        dataBindingAndUpdateUI()
    }

    // MARK: - Private methods
    private func dataBindingAndUpdateUI() {
        realmDataManager.$fetchedTasks
            .sink { [weak self] _ in
                self?.view?.updateUI()
            }
            .store(in: &cancellables)
    }

    // MARK: - Public methods
    func filterTasks(with filterText: String) {
        realmDataManager.filterTasks(with: filterText)
    }

    func fetchTasksNotSearchMode() {
        realmDataManager.fetchTasks()
    }

    func deleteTask(indexPath: IndexPath) {
        realmDataManager.deleteTask(indexPath: indexPath)
    }

    func getTasksCount() -> Int {
        return realmDataManager.fetchedTasks?.count ?? 0
    }

    func getCategoryName() -> String {
        return realmDataManager.getSelectedCategoryFromCDM()
    }

    func getTaskName(_ indexPath: IndexPath) -> String {
        realmDataManager.fetchedTasks?[indexPath.row].taskName ?? "Issue"
    }

    func getTaskDate(_ indexPath: IndexPath) -> Date {
        realmDataManager.fetchedTasks?[indexPath.row].createdDate ?? Date()
    }

    func getColorHex(_ indexPath: IndexPath) -> String {
        colorsArray[indexPath.row]
    }

    func plusButtonTapped() {
        view?.showAlert()
    }
}

