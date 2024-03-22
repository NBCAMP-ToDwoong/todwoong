//
//  Todo+CoreDataProperties.swift
//  ToDwoong
//
//  Created by 홍희곤 on 3/22/24.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var dueTime: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var placeName: String?
    @NSManaged public var timeAlarm: [Int]?
    @NSManaged public var title: String?
    @NSManaged public var group: Group?
    @NSManaged public var placeAlarm: PlaceAlarm?

}

extension Todo: Identifiable {

}
