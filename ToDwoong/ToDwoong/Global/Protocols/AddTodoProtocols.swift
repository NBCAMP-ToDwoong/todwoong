//
//  AddTodoProtocols.swift
//  ToDwoong
//
//  Created by yen on 3/10/24.
//

import UIKit

protocol LocationPickerDelegate: AnyObject {
    func didPickLocation(_ address: String, latitude: Double, longitude: Double)
}

protocol GroupSelectModalDelegate: AnyObject {
    func groupSelectController(_ controller: GroupSelectModal, didSelectGroup group: Group)
}

protocol TimeAlarmModalDelegate: AnyObject {
    func timesSelected(_ times: [String])
}

protocol PlaceAlarmModalDelegate: AnyObject {
    func locationSelected(_ location: [String])
}

protocol DatePickerModalDelegate: AnyObject {
    func didSelectDate(_ date: Date)
}

protocol TimePickerModalDelegate: AnyObject {
    func didSelectTime(_ date: Date)
}
