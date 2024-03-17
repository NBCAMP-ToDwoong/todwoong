//
//  AddTodoProtocols.swift
//  ToDwoong
//
//  Created by yen on 3/10/24.
//

import UIKit

protocol LocationPickerViewDelegate: AnyObject {
    func didTapConfirmAddress(_ address: String)
}

protocol LocationPickerDelegate: AnyObject {
    func didPickLocation(_ address: String)
}

protocol GroupSelectControllerDelegate: AnyObject {
    func groupSelectController(_ controller: AddTodoGroupSelectController, didSelectGroup category: Category)
}

protocol TimeAlarmSelectControllerDelegate: AnyObject {
    func timesSelected(_ times: [String])
}

protocol PlaceAlarmSelectControllerDelegate: AnyObject {
    func locationSelected(_ location: [String])
}

protocol DatePickerModalDelegate: AnyObject {
    func didSelectDate(_ date: Date)
}

protocol TimePickerModalDelegate: AnyObject {
    func didSelectTime(_ date: Date)
}
