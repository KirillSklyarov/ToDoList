//
//  ViewController.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import UIKit
import Chameleon

protocol MainVCProtocol: AnyObject {
    func showAlert()
    func updateUI()
}

final class MainViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var categoryTable: UITableView = {
        return setupAppTableView()
    } ()

    // MARK: - Other Properties
    private var presenter: MainPresenterProtocol

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
        getData()
    }

    override func viewWillAppear(_ animated: Bool) {
        setupNavigation()
    }

    // MARK: - IB Action
    @objc private func plusButtonTapped(sender: UIButton) {
        presenter.plusButtonTapped()
    }

    // MARK: - Private methods
    private func getData() {
        presenter.getDataFromCoreData()
    }

    private func setupUI() {
        view.backgroundColor = .white
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

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
    }
}

// MARK: - MainVCProtocol
extension MainViewController: MainVCProtocol {
    func showAlert() {
        let alertController = AlertController()
        alertController.showAlert(screens: .Main, from: self)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) else { return UITableViewCell() }
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskVC = ScreenFactory.createScreen(.Task)
        presenter.passSelectedCategory(indexPath: indexPath)
        navigationController?.pushViewController(taskVC, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self]  _,_,_ in
            self?.presenter.deleteCategory(indexPath: indexPath)
        }
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    private func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        let categoryName = presenter.getCategoryName(indexPath)
        cell.textLabel?.text = categoryName
        cell.textLabel?.textColor = .white
        cell.backgroundColor = presenter.getCategoryColor(indexPath)
        cell.selectionStyle = .none
    }
}
