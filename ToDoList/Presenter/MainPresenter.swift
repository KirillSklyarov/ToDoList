//
//  MainPresenter.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import Foundation
import Combine

protocol MainPresenterProtocol: AnyObject {
    func getCategoryCount() -> Int
    func getCategoryName(_ indexPath: IndexPath) -> String
    func getColorHex(_ indexPath: IndexPath) -> String
    func plusButtonTapped()
    func passSelectedCategory(_ categoryName: String)
    func deleteCategory(indexPath: IndexPath)
    func getDataFromCoreData()
}

final class MainPresenter {

    // MARK: - View
    weak var view: MainVCProtocol?

    // MARK: - Private properties
    private let colorsArray = Constants.randomColorArray
    private var cdManager: CoreDataManager
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init
    init(cdManager: CoreDataManager = CoreDataManager.shared) {
        self.cdManager = cdManager
        dataBindingAndUpdateUI()
    }

    // MARK: - Private methods
    private func dataBindingAndUpdateUI() {
        cdManager.$fetchedCategories
            .sink { [weak self]  _ in
                guard let self else { print("Ooops"); return }
                self.view?.updateUI()
            }
            .store(in: &cancellables)
    }
}

// MARK: - MainPresenterProtocol
extension MainPresenter: MainPresenterProtocol {

    func getDataFromCoreData() {
        cdManager.fetchCategories()
    }

    func deleteCategory(indexPath: IndexPath) {
        cdManager.deleteCategoryNEW(indexPath: indexPath)
    }

    func passSelectedCategory(_ categoryName: String) {
        cdManager.getSelectedCategory(categoryName)
        cdManager.fetchTasks()
    }

    func plusButtonTapped() {
        view?.showAlert()
    }

    func getCategoryCount() -> Int {
        cdManager.fetchedCategories?.count ?? 0
    }

    func getCategoryName(_ indexPath: IndexPath) -> String {
        cdManager.fetchedCategories![indexPath.row].categoryName!
    }

    func getColorHex(_ indexPath: IndexPath) -> String {
        colorsArray[indexPath.row]
    }
}
