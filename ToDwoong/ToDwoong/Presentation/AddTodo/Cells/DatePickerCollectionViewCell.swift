//
//  DatePickerCollectionViewCell.swift
//  ToDwoong
//
//  Created by mirae on 3/2/24.
//

import UIKit

import SnapKit

class DatePickerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let datePicker = UIDatePicker()
    weak var delegate: DateTimePickerDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setDatePicker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setDatePicker()
    } 
    
}

// MARK: setDatePicker

extension DatePickerCollectionViewCell {
    private func setDatePicker() {
        addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
}

// MARK: configure

extension DatePickerCollectionViewCell {
    func configure(for mode: UIDatePicker.Mode) {
        datePicker.datePickerMode = mode
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = mode == .date ? .inline : .wheels
        }
    }
}

// MARK: @objc

extension DatePickerCollectionViewCell {
    @objc func datePickerValueChanged(_ datePicker: UIDatePicker) {
        let mode = datePicker.datePickerMode
        let selectedDate = datePicker.date

        delegate?.didPickDateOrTime(date: selectedDate, mode: mode)
    }
}
