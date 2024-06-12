//
//  ViewController.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import UIKit

protocol MainVCProtocol: AnyObject {
    func showAlert()
    func updateUI()
}

final class MainViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var categoryTable: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    } ()

    // MARK: - Other Properties
    private var presenter: MainPresenterProtocol

    private var cdManager = CoreDataManager.shared

    // MARK: - Init
    init(presenter: MainPresenterProtocol) {
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
        fetchData()
    }

    // MARK: - IB Action
    @objc private func plusButtonTapped(sender: UIButton) {
        presenter.plusButtonTapped()
    }

    // MARK: - Private methods
    private func fetchData() {
        cdManager.fetchData()
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
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white


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

// MARK: - MainVCProtocol
extension MainViewController: MainVCProtocol {
    func showAlert() {
        let alertController = AlertController()
        alertController.showAnyAlert(screens: .Main, from: self)
    }

    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.categoryTable.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getCategoryCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self]  _,_,_ in
            self?.presenter.deleteCategory(indexPath: indexPath)
        }
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskVC = ScreenFactory.createScreen(.Task)
        passSelectedCategory(indexPath: indexPath)
        navigationController?.pushViewController(taskVC, animated: true)
    }

    private func passSelectedCategory(indexPath: IndexPath) {
        guard let cell = categoryTable.cellForRow(at: indexPath),
              let categoryName = cell.textLabel?.text else { return }
        presenter.passSelectedCategory(categoryName)
    }

    private func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        let categoryName = presenter.getCategoryName(indexPath)
        cell.textLabel?.text = categoryName
        cell.textLabel?.textColor = .white

        let colorString = presenter.getColorHex(indexPath)
        cell.backgroundColor = UIColor(hexString: colorString)
        cell.selectionStyle = .none
    }
}
