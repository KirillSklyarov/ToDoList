//
//  MainPresenter.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import Foundation
import Combine
import Chameleon

protocol MainPresenterProtocol: AnyObject {
    func getCategoryCount() -> Int
    func getCategoryName(_ indexPath: IndexPath) -> String
    func plusButtonTapped()
    func passSelectedCategory(indexPath: IndexPath)
    func deleteCategory(indexPath: IndexPath)
    func getDataFromCoreData()
    func getRandomColor() -> UIColor
    func getCategoryColor(_ indexPath: IndexPath) -> UIColor
}

final class MainPresenter {

    // MARK: - View
    weak var view: MainVCProtocol?

    // MARK: - Private properties
    private var realmDataManager: RealmDataManager
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init
    init(realmDataManager: RealmDataManager = RealmDataManager.shared) {
        self.realmDataManager = realmDataManager
        dataBindingAndUpdateUI()
    }

    // MARK: - Private methods
    private func dataBindingAndUpdateUI() {
        realmDataManager.$fetchedCategories
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
        realmDataManager.fetchCategories()
    }

    func deleteCategory(indexPath: IndexPath) {
        realmDataManager.deleteCategory(indexPath: indexPath)
    }

    func passSelectedCategory(indexPath: IndexPath) {
        realmDataManager.setSelectedCategory(indexPath: indexPath)
        realmDataManager.fetchTasks()
    }

    func plusButtonTapped() {
        view?.showAlert()
    }

    func getCategoryCount() -> Int {
        realmDataManager.fetchedCategories?.count ?? 0
    }

    func getCategoryName(_ indexPath: IndexPath) -> String {
        realmDataManager.fetchedCategories?[indexPath.row].categoryName ?? "Issue"
    }

    func getCategoryColor(_ indexPath: IndexPath) -> UIColor {
        let colorHex = realmDataManager.fetchedCategories?[indexPath.row].color ?? "FFFFF"
        return UIColor(hexString: colorHex)
    }

    func getRandomColor() -> UIColor {
        UIColor.randomFlat()
    }

    func getChameleonColorHex() -> String {
        let color = getRandomColor()
        return color.hexValue()
    }
}
