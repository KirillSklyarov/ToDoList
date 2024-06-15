//
//  RealmData.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 14.06.2024.
//

import Foundation
import RealmSwift

final class Category: Object {
    @objc dynamic var categoryName: String = ""
    @objc dynamic var color: String = ""
    var tasks = List<Tasks>()
}

