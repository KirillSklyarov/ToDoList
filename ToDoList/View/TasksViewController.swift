//
//  TasksViewController.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import UIKit
import ChameleonSwift

protocol TasksVCProtocol: AnyObject {
    func showAlert()
    func updateUI()
}

final class TasksViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var tasksTable: UITableView = {
        return setupAppTableView()
    } ()

    private lazy var placeholderImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "x.circle.fill")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        imageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        return imageView
    } ()
    private lazy var placeholderText: UILabel = {
        let label = UILabel()
        label.text = "У тебя пока нет заданий в этой категории"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    } ()
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchResultsUpdater = self
        search.searchBar.searchTextField.backgroundColor = .white
        return search
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
        setupUI()
        showOrHidePlaceholder()
    }

    override func viewWillAppear(_ animated: Bool) {
        setupNavigation()
    }

    // MARK: - IB Action
    @objc private func plusButtonTapped(sender: UIButton) {
        presenter.plusButtonTapped()
    }

    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .white
    }

    private func setupNavigation() {
        title = presenter.getCategoryName()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        let appearance = UINavigationBarAppearance()
        let color = presenter.getNavBarColor()
        let titleColor = ContrastColorOf(color, returnFlat: true)
        appearance.backgroundColor = color
        appearance.largeTitleTextAttributes = [.foregroundColor: titleColor]
        appearance.titleTextAttributes = [.foregroundColor: titleColor]
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
    }

    private func showOrHidePlaceholder() {
        let tasksCount = presenter.getTasksCount()
        if tasksCount == 0 {
            showPlaceholder()
        } else {
            hidePlaceholder()
        }
    }

    private func showPlaceholder() {
        tasksTable.isHidden = true
        placeholderImage.isHidden = false
        placeholderText.isHidden = false

        let container = UIView()
        container.addSubview(placeholderImage)
        NSLayoutConstraint.activate([
            placeholderImage.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])

        let stack = UIStackView(arrangedSubviews: [container, placeholderText])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            placeholderText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            placeholderText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }

    private func hidePlaceholder() {
        tasksTable.isHidden = false
        placeholderImage.isHidden = true
        placeholderText.isHidden = true
    }
}

// MARK: - TasksVCProtocol
extension TasksViewController: TasksVCProtocol {
    
    func showAlert() {
        let alertController = AlertController()
        alertController.showAlert(screens: .Task, from: self)
    }

    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.showOrHidePlaceholder()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) else { return UITableViewCell() }
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self]  _,_,_ in
            self?.presenter.deleteTask(indexPath: indexPath)
        }
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    private func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        let taskName = presenter.getTaskName(indexPath)
        let color = presenter.getGradientColor(indexPath)

        cell.textLabel?.text = taskName
        cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)

        cell.backgroundColor = color
        cell.selectionStyle = .none
    }
}

// MARK: - UISearchResultsUpdating
extension TasksViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if !searchText.isEmpty {
            presenter.filterTasks(with: searchText)
        } else {
            presenter.fetchTasksNotSearchMode()
        }
    }
}
