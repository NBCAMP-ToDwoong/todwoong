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

protocol DateTimePickerDelegate: AnyObject {
    func didPickDateOrTime(date: Date, mode: UIDatePicker.Mode)
}

protocol TitleCollectionViewCellDelegate: AnyObject {
    func titleCellDidEndEditing(_ text: String?)
}

