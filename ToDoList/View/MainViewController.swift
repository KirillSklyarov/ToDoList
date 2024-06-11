//
//  ViewController.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import UIKit

protocol MainVCDelegateProtocol: AnyObject {
    func getTasksName(categoryName: String)
}

protocol MainVCProtocol: AnyObject {
    func showAlert()
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
    var presenter: MainPresenterProtocol
    weak var delegate: MainVCDelegateProtocol?

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
        presenter.updateData()
        setupUI()
    }

    // MARK: - IB Action
    @objc private func plusButtonTapped(sender: UIButton) {
        presenter.plusButtonTapped()
    }

    // MARK: - Private methods
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

// MARK: - MainVCProtocol
extension MainViewController: MainVCProtocol {
    func showAlert() {
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
                presenter.addNewCategory(newCategoryName: newCatName)
                self.updateUI()
            }
        })

        present(alert, animated: true)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskVC = ScreenFactory.createScreen(.Task)
        completeDelegate(taskVC, indexPath: indexPath)
        navigationController?.pushViewController(taskVC, animated: true)
    }

    private func completeDelegate(_ viewController: UIViewController, indexPath: IndexPath) {
        guard let castVC = viewController as? MainVCDelegateProtocol else { print("Casting issue"); return }
        self.delegate = castVC
        guard let cell = categoryTable.cellForRow(at: indexPath),
              let categoryName = cell.textLabel?.text else { return }
        delegate?.getTasksName(categoryName: categoryName)
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
