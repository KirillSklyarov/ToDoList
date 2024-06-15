//
//  TasksPresenter.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import Foundation
import Combine
import Chameleon

protocol TasksPresenterProtocol: AnyObject {
    func plusButtonTapped()
    func getTasksCount() -> Int
    func getTaskName(_ indexPath: IndexPath) -> String
    func getCategoryName() -> String
    func deleteTask(indexPath: IndexPath)
    func filterTasks(with filterText: String)
    func fetchTasksNotSearchMode()
    func getTaskDate(_ indexPath: IndexPath) -> Date
    func getGradientColor(_ indexPath: IndexPath) -> UIColor
    func getNavBarColor() -> UIColor
}

final class TasksPresenter: TasksPresenterProtocol {

    // MARK: - Properties
    weak var view: TasksVCProtocol?
    private var realmDataManager: RealmDataManager
    private var cancellables: Set<AnyCancellable> = []

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
        let taskName = realmDataManager.fetchedTasks?[indexPath.row].taskName ?? "Issue"
        let date = realmDataManager.fetchedTasks?[indexPath.row].createdDate ?? Date()
        let formattedDate = DateFormatter.fromDateToString(date: date)
        let text = taskName+" "+"(\(formattedDate))"
        return text
    }

    func getTaskDate(_ indexPath: IndexPath) -> Date {
        realmDataManager.fetchedTasks?[indexPath.row].createdDate ?? Date()
    }

    func getGradientColor(_ indexPath: IndexPath) -> UIColor {
        let index = indexPath.row
        let totalTasks = realmDataManager.fetchedTasks?.count ?? 1
        let percent = Double(index) / Double(totalTasks)
        let color = realmDataManager.getSelectedCategoryColor()
        guard let colorAsColor = UIColor(hexString: color),
              let taskColor = colorAsColor.darken(byPercentage: percent) else { return UIColor.black }
        return taskColor
    }

    func getNavBarColor() -> UIColor {
        let color = realmDataManager.getSelectedCategoryColor()
        guard let colorAsColor = UIColor(hexString: color) else { return UIColor.black }
        return colorAsColor
    }

    func plusButtonTapped() {
        view?.showAlert()
    }
}
