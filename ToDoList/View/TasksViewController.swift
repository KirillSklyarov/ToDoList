//
//  TasksViewController.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import UIKit

final class TasksViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var tasksTable: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    } ()

    // MARK: - Other Properties
    private var data = [DataModel]()
    private var newCat = ""
    private let colorsArray = Constants.randomColorArray
    private var tasks = [String]()
    private var categoryName = ""

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
        setupUI()
    }

    // MARK: - IB Action
    @objc private func plusButtonTapped(sender: UIButton) {
        showAlert()
    }

    // MARK: - Private methods
    private func setupUI() {
        setupNavigation()

        view.backgroundColor = .white
        setupTableView()
    }

    private func setupNavigation() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .white

        let plusButton = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: plusButton, style: .plain, target: self, action: #selector(plusButtonTapped))
    }

    private func setupTableView() {
        view.addSubview(tasksTable)

        tasksTable.backgroundColor = .white

        NSLayoutConstraint.activate([
            tasksTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tasksTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tasksTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tasksTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Alert
extension TasksViewController {
    private func showAlert() {
        let alert = UIAlertController(title: "Добавь новое задание", message: nil, preferredStyle: .alert)

        alert.addTextField() { textfield in
            textfield.placeholder = "Введите новое задание"
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Добавить", style: .default) { [weak self] textField in
            guard let self,
                  let textField = alert.textFields?.first,
                  let newTaskName = textField.text else { return }
            if !newTaskName.isEmpty {
                self.addNewTask(newTaskName: newTaskName)
                self.updateUI()
            }
        })

        present(alert, animated: true)
    }

    private func addNewTask(newTaskName: String) {
        tasks.append(newTaskName)
        addNewListOfTaskToStorage()
        updateData()
    }

    private func addNewListOfTaskToStorage() {
        let index = MockData.data.firstIndex { $0.categoryName == categoryName }
        if let keyIndex = index {
            MockData.data[keyIndex].taskName = tasks
        }
    }

    private func updateData() {
        getTasksName(categoryName: categoryName)
    }

    private func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.tasksTable.reloadData()
        }
    }
}

// MARK: - MainVCDelegateProtocol
extension TasksViewController: MainVCDelegateProtocol {
    func getTasksName(categoryName: String) {
        let data = MockData.data
        let filteredData = data.filter { $0.categoryName == categoryName }
        if let taskNames = filteredData.first?.taskName {
            tasks = taskNames
            self.categoryName = categoryName
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }

    private func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        let taskName = tasks[indexPath.row]
        cell.textLabel?.text = taskName
        cell.textLabel?.textColor = .white

        let colorString = colorsArray[indexPath.row]
        cell.backgroundColor = UIColor(hexString: colorString)
        cell.selectionStyle = .none
    }
}
