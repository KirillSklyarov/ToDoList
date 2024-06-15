//
//  dateFormatter.swift
//  ToDoList
//
//  Created by Kirill Sklyarov on 15.06.2024.
//

import Foundation

extension DateFormatter {

    static let appFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ru_Ru")
        return formatter
    }()

    static func fromDateToString(date: Date) -> String {
        appFormatter.string(from: date)
    }
}
