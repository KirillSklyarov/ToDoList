//
//  MockData.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 11.06.2024.
//

import Foundation

struct MockData {
    static var data: [DataModel] = [
        DataModel(categoryName: "Home", taskName: ["first1", "second1", "third1"]),
        DataModel(categoryName: "Work", taskName: ["first2", "second2", "third2"]),
        DataModel(categoryName: "Learn", taskName: ["first3", "second3", "third3"]),
        DataModel(categoryName: "Eat", taskName: ["first4", "second4", "third4"]),
        DataModel(categoryName: "Shopping List", taskName: ["first5", "second5", "third5"]),
    ]
}
