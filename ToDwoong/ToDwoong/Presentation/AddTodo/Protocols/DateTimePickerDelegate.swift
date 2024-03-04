//
//  DateTimePickerDelegate.swift
//  ToDwoong
//
//  Created by mirae on 3/5/24.
//

protocol DateTimePickerDelegate: AnyObject {
    func didPickDateOrTime(date: Date, mode: UIDatePicker.Mode)
}
