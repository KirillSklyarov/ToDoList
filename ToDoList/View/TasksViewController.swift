//
//  TasksViewController.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import UIKit

protocol TasksVCProtocol: AnyObject {
    func showAlert()
}

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
    var presenter: TasksPresenterProtocol

    // MARK: - Init
    init(presenter: TasksPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.updateData()
        setupUI()
    }

    // MARK: - IB Action
    @objc private func plusButtonTapped(sender: UIButton) {
        presenter.plusButtonTapped()
    }

    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .white
        setupNavigation()
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

// MARK: - MainVCDelegateProtocol
extension TasksViewController: MainVCDelegateProtocol {
    func getTasksName(categoryName: String) {
        presenter.getTasksName(categoryName: categoryName)
    }
}

// MARK: - TasksVCProtocol
extension TasksViewController: TasksVCProtocol {
    func showAlert() {
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
                presenter.addNewTask(newTaskName: newTaskName)
                self.updateUI()
            }
        })

        present(alert, animated: true)
    }

    private func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.tasksTable.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getTasksCount()
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
        let taskName = presenter.getTaskName(indexPath)
        cell.textLabel?.text = taskName
        cell.textLabel?.textColor = .white

        let colorString = presenter.getColorHex(indexPath)
        cell.backgroundColor = UIColor(hexString: colorString)
        cell.selectionStyle = .none
    }
}
