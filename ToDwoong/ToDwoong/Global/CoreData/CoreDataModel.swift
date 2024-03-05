//
//  CoreDataModel.swift
//  ToDwoong
//
//  Created by yen on 3/5/24.
//

import Foundation

class CategoryModel {
    var id: UUID?
    var title: String
    var color: String?
    var indexNumber: Int32?
    var todo: Todo?

    init(color: String?, id: UUID?, indexNumber: Int32?, title: String) {
        self.id = id
        self.title = title
        self.color = color
        self.indexNumber = indexNumber
    }
}

class TodoModel{
    var id: UUID?
    var title: String
    var dueDate: Date?
    var dueTime: Date?
    var timeAlarm: Bool
    var place: String?
    var placeAlarm: Bool
    var isCompleted: Bool
    var fixed: Bool
    weak var category: Category?

    init(dueDate: Date?, dueTime: Date?, fixed: Bool, id: UUID?, isCompleted: Bool, place: String?, placeAlarm: Bool, timeAlarm: Bool, title: String, category: Category?) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.dueTime = dueTime
        self.timeAlarm = timeAlarm
        self.place = place
        self.placeAlarm = placeAlarm
        self.isCompleted = isCompleted
        self.fixed = fixed
        self.category = category
    }
}
