//
//  RealmData.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 14.06.2024.
//

import Foundation
import RealmSwift

final class CategoryCD: Object {
    @objc dynamic var categoryName: String = ""
    var tasks = List<TasksCD>()
}

