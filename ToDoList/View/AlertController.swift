//
//  AlertController.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import UIKit

final class AlertController: UIAlertController {

    func showAlert(screens: ScreenFactory.Screens, from viewController: UIViewController) {
        switch screens {
        case .Main: showAlertForMain(from: viewController)
        case .Task: showAlertForTask(from: viewController)
        }
    }

    func showAlertForMain(from viewController: UIViewController) {
        let alert = UIAlertController(title: "Добавь новую категорию", message: nil, preferredStyle: .alert)

        alert.addTextField() { textfield in
            textfield.placeholder = "Введите новую категорию"
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Добавить", style: .default) { textField in
            guard let textField = alert.textFields?.first,
                  let newCatName = textField.text else { return }
            if !newCatName.isEmpty {
                RealmDataManager.shared.createCategory(newCategoryName: newCatName)
            }
        })

        viewController.present(alert, animated: true)
    }

    func showAlertForTask(from viewController: UIViewController) {
        let alert = UIAlertController(title: "Добавь новое задание", message: nil, preferredStyle: .alert)

        alert.addTextField() { textfield in
            textfield.placeholder = "Введите новое задание"
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Добавить", style: .default) { textField in
            guard let textField = alert.textFields?.first,
                  let newTaskName = textField.text else { return }
            if !newTaskName.isEmpty {
                RealmDataManager.shared.createTask(newTaskName: newTaskName)
            }
        })

        viewController.present(alert, animated: true)
    }
}
