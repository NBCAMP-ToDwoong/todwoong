//
//  Todo+Extension.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 3/9/24.
//

import UIKit

import TodwoongDesign

extension Todo {
    func toTodoModel() -> TodoModel {
        return TodoModel(id: self.id,
                         title: self.title ?? "",
                         dueDate: self.dueDate,
                         dueTime: self.dueTime,
                         place: self.place,
                         isCompleted: self.isCompleted,
                         fixed: self.fixed,
                         timeAlarm: self.timeAlarm,
                         placeAlarm: self.placeAlarm,
                         category: self.category?.toCategoryModel())
    }
}

extension Category {
    func toCategoryModel() -> CategoryModel {
        return CategoryModel(id: self.id,
                             title: self.title ?? "",
                             color: self.color,
                             indexNumber: self.indexNumber,
                             todo: nil)
    }
}
