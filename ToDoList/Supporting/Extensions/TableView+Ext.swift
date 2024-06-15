//
//  TableView+Ext.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 15.06.2024.
//

import UIKit

extension UIViewController {

    func setupAppTableView() -> UITableView {
        let table = UITableView()
        table.rowHeight = Constants.cellHeight
        table.dataSource = self as? UITableViewDataSource
        table.delegate = self as? UITableViewDelegate
        table.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(table)

        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        return table
    }
}
