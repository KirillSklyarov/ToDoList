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
    func updateData()
    func plusButtonTapped()
    func addNewCategory(newCategoryName: String)
}

final class MainPresenter: MainPresenterProtocol {

    var data = [DataModel]()
    var newCat = ""
    let colorsArray = Constants.randomColorArray

    weak var view: MainVCProtocol?

    func plusButtonTapped() {
        view?.showAlert()
    }

    func addNewCategory(newCategoryName: String) {
        let newCat = DataModel(categoryName: newCategoryName, taskName: [])
        MockData.data.append(newCat)
        updateData()
    }


    func getCategoryCount() -> Int {
        data.count
    }

    func getCategoryName(_ indexPath: IndexPath) -> String {
        data[indexPath.row].categoryName
    }

    func getColorHex(_ indexPath: IndexPath) -> String {
        colorsArray[indexPath.row]
    }

    func updateData() {
        data = MockData.data
    }



}
