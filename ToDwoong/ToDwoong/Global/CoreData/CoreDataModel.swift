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
    var timeAlarm: [Double]?
    var placeName: String?
    weak var group: GroupType?
    weak var placeAlarm: PlaceAlarmType?

    init(id: UUID, 
         title: String,
         isCompleted: Bool,
         dueTime: Date? = nil,
         timeAlarm: [Double]? = nil,
         placeName: String? = nil,
         group: GroupType? = nil,
         placeAlarm: PlaceAlarmType? = nil
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.dueTime = dueTime
        self.timeAlarm = timeAlarm
        self.placeName = placeName
        self.group = group
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

struct TodoUpdateInfo {
    var id: UUID
    var newTitle: String?
    var newIsCompleted: Bool?
    var newDueTime: Date?
    var newTimeAlarm: [Double]?
    var newPlaceName: String?
    var newGroup: Group?
    var newPlaceAlarm: PlaceAlarm?
}

struct GroupUpdateInfo {
    var id: UUID
    var newTitle: String?
    var newColor: String?
    var newIndexNumber: Int32?
}
