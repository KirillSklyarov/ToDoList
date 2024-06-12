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
}

final class MainPresenter {

    // MARK: - View
    weak var view: MainVCProtocol?

    // MARK: - Private properties
    private let colorsArray = Constants.randomColorArray
    private var storage: DataStorage
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init
    init(storage: DataStorage) {
        self.storage = storage
        dataBindingAndUpdateUI()
    }

    // MARK: - Private methods
    private func dataBindingAndUpdateUI() {
        storage.$data
            .sink { [weak self] _ in
                guard let self else { print("Ooops"); return }
                self.view?.updateUI()
            }
            .store(in: &cancellables)
    }
}

// MARK: - MainPresenterProtocol
extension MainPresenter: MainPresenterProtocol {

    func deleteCategory(indexPath: IndexPath) {
        let index = indexPath.row
        storage.deleteCategory(categoryIndex: index)
    }

    func passSelectedCategory(_ categoryName: String) {
        storage.getTasksName(categoryName: categoryName)
    }

    func plusButtonTapped() {
        view?.showAlert()
    }

    func getCategoryCount() -> Int {
        storage.data.count
    }

    func getCategoryName(_ indexPath: IndexPath) -> String {
        storage.data[indexPath.row].categoryName
    }

    func getColorHex(_ indexPath: IndexPath) -> String {
        colorsArray[indexPath.row]
    }
}
