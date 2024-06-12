//
//  TasksViewController.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import UIKit

protocol TasksVCProtocol: AnyObject {
    func showAlert()
    func updateUI()
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
        title = presenter.getCategoryName()
        navigationItem.largeTitleDisplayMode = .never

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

    private func showOrHidePlaceholder() {
        if presenter.getTasksCount() == 0 {
            showPlaceholder()
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
}

// MARK: - TasksVCProtocol
extension TasksViewController: TasksVCProtocol {
    func showAlert() {
        let alertController = AlertController()
        alertController.showAnyAlert(screens: .Task, from: self)
    }

    func updateUI() {
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
