//
//  MainPresenter.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func getCategoryCount() -> Int
    func getCategoryName(_ indexPath: IndexPath) -> String
    func getColorHex(_ indexPath: IndexPath) -> String
    func plusButtonTapped()
    func passSelectedCategory(_ categoryName: String)
}

final class MainPresenter: MainPresenterProtocol {

    let colorsArray = Constants.randomColorArray

    weak var view: MainVCProtocol?
    var storage: DataStorage

    init(storage: DataStorage) {
        self.storage = storage
        updateUI()
    }

    func updateUI() {
        storage.tasksUpdated = { [weak self] in
            self?.view?.updateUI()
        }
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
