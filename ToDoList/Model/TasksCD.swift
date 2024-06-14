//
//  TasksCD-Realm.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 14.06.2024.
//

import Foundation
import RealmSwift

final class TasksCD: Object {
    @objc dynamic var taskName: String = ""
    var parentCategory = LinkingObjects(fromType: CategoryCD.self, property: "tasks")
}
