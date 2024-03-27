//
//  AddTodoProtocols.swift
//  ToDwoong
//
//  Created by yen on 3/10/24.
//

import UIKit

protocol AddTodoLocationPickerViewDelegate: AnyObject {
    func didTapConfirmAddress(_ address: String)
}

protocol AddTodoLocationPickerDelegate: AnyObject {
    func didPickLocation(_ address: String)
}

protocol AddTodoGroupSelectControllerDelegate: AnyObject {
    func groupSelectController(_ controller: AddTodoGroupSelectController, didSelectGroup category: Category)
}

protocol AddTodoTimeAlarmSelectControllerDelegate: AnyObject {
    func timesSelected(_ times: [String])
}

protocol AddTodoPlaceAlarmSelectControllerDelegate: AnyObject {
    func locationSelected(_ location: [String])
}

protocol DatePickerModalDelegate: AnyObject {
    func didSelectDate(_ date: Date)
}

protocol TimePickerModalDelegate: AnyObject {
    func didSelectTime(_ date: Date)
}
