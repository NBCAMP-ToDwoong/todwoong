//
//  Model.swift
//  ToDwoong
//
//  Created by yen on 3/17/24.
//

import Foundation

class TodoType {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var dueTime: Date?
    var placeName: String?
    var timeAlarm: [Int]?
    
    weak var group: GroupType?
    weak var placeAlarm: PlaceAlarmType?
    
    init(id: UUID,
         title: String,
         isCompleted: Bool,
         dueTime: Date? = nil,
         placeName: String? = nil,
         timeAlarm: [Int]? = nil,
         group: GroupType? = nil,
         placeAlarm: PlaceAlarmType? = nil
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.dueTime = dueTime
        self.placeName = placeName
        self.group = group
        self.timeAlarm = timeAlarm
        self.placeAlarm = placeAlarm
    }
}

class GroupType {
    let id: UUID
    var title: String
    var color: String?
    var indexNumber: Int32?
    weak var todo: TodoType?

    init(id: UUID,
         title: String,
         color: String? = nil,
         indexNumber: Int32? = nil,
         todo: TodoType? = nil
    ) {
        self.id = id
        self.title = title
        self.color = color
        self.indexNumber = indexNumber
        self.todo = todo
    }
}

class PlaceAlarmType {
    var distance: Int32
    var latitude: Double
    var longitude: Double
    weak var todo: TodoType?

    init(distance: Int32,
         latitude: Double,
         longitude: Double,
         todo: TodoType? = nil
    ) {
        self.distance = distance
        self.latitude = latitude
        self.longitude = longitude
        self.todo = todo
    }
}

struct TodoDTO {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var dueTime: Date?
    var placeName: String?
    var group: Group?
}

struct TodoUpdateDTO {
    var id: UUID
    var title: String?
    var isCompleted: Bool?
    var dueTime: Date?
    var placeName: String?
    var timeAlarm: [Int]?
    var group: Group?
    var placeAlarm: PlaceAlarm?
}

struct GroupUpdateDTO {
    var id: UUID
    var title: String?
    var color: String?
}
