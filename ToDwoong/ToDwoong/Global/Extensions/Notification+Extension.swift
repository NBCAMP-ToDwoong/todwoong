//
//  Notification+Extension.swift
//  ToDwoong
//
//  Created by yen on 3/11/24.
//

import Foundation

extension Notification.Name {
    static let TodoDataUpdatedNotification = Notification.Name("TodoDataUpdatedNotification")
    static let GroupDataUpdatedNotification = Notification.Name("GroupDataUpdatedNotification")
    static let todoDeleted = Notification.Name("todoDeletedNotification")
}
