//
//  TasksCD-Realm.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 14.06.2024.
//

import Foundation
import RealmSwift

final class Tasks: Object {
    @objc dynamic var taskName: String = ""
    @objc dynamic var createdDate: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "tasks")
}
