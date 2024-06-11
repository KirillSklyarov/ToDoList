//
//  ViewController.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import UIKit

final class MainViewController: UIViewController {

    private lazy var categoryTable: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    } ()

    private var data = MockData.data
    private var newCat = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }


    @objc private func plusButtonTapped(sender: UIButton) {
        showAlert()
    }

    private func setupUI() {
        setupNavigation()

        view.backgroundColor = .white
        setupTableView()
    }

    private func setupNavigation() {
        title = "Todoey"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(hexString: "778beb")
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true

        let plusButton = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal)

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: plusButton, style: .plain, target: self, action: #selector(plusButtonTapped))
    }

    private func setupTableView() {
        view.addSubview(categoryTable)

        categoryTable.backgroundColor = .white

        NSLayoutConstraint.activate([
            categoryTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension MainViewController {
    private func showAlert() {
        let alert = UIAlertController(title: "Добавь новую категорию", message: nil, preferredStyle: .alert)

        alert.addTextField() { textfield in
            textfield.placeholder = "Введите новую категорию"
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Добавить", style: .default) { [weak self] textField in
            guard let self,
                  let textField = alert.textFields?.first,
                  let newCatName = textField.text else { return }
            if !newCatName.isEmpty {
                self.addNewCategory(newCategoryName: newCatName)
                self.updateUI()
            }
        })

        present(alert, animated: true)
    }

    private func addNewCategory(newCategoryName: String) {
        let newCat = DataModel(categoryName: newCategoryName, taskName: [])
        MockData.data.append(newCat)
        data = MockData.data
        print(MockData.data)
    }

    private func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.categoryTable.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskVC = TasksViewController()
        navigationController?.pushViewController(taskVC, animated: true)
    }

    private func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        let categoryName = data[indexPath.row].categoryName
        cell.textLabel?.text = categoryName
        cell.textLabel?.textColor = .white

        let randomColorArray = Constants.colorsHex.shuffled()
        let colorString = randomColorArray[indexPath.row]
        cell.backgroundColor = UIColor(hexString: colorString)
        cell.selectionStyle = .none
    }
}
