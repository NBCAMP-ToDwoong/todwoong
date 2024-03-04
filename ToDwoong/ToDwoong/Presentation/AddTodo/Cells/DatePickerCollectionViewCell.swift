//
//  DatePickerCollectionViewCell.swift
//  ToDwoong
//
//  Created by mirae on 3/2/24.
//

import UIKit

import SnapKit

protocol DateTimePickerDelegate: AnyObject {
    func didPickDateOrTime(date: Date, mode: UIDatePicker.Mode)
}

final class DatePickerCollectionViewCell: UICollectionViewCell {
    
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
    
    private func setDatePicker() {
        addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(_ datePicker: UIDatePicker) {
        let calendar = Calendar.current
        var adjustedDate: Date?
        
        switch datePicker.datePickerMode {
        case .time:
            let timeComponents = calendar.dateComponents([.hour, .minute], from: datePicker.date)
            adjustedDate = calendar.date(from: DateComponents(year: 1900, month: 1,
                                                              day: 1, hour: timeComponents.hour,
                                                              minute: timeComponents.minute))
        case .date:
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: datePicker.date)
            adjustedDate = calendar.date(from: DateComponents(year: dateComponents.year,
                                                              month: dateComponents.month,
                                                              day: dateComponents.day))
        default:
            adjustedDate = datePicker.date
        }
        
        if let adjustedDate = adjustedDate {
            delegate?.didPickDateOrTime(date: adjustedDate, mode: datePicker.datePickerMode)
        } else {
            print("Set current date and time if no value is selected")
            let currentDate = Date()
            delegate?.didPickDateOrTime(date: currentDate, mode: datePicker.datePickerMode)
        }
    }
    
    func configure(for mode: UIDatePicker.Mode, selectedDate: Date? = nil) {
        datePicker.datePickerMode = mode
        if let selectedDate = selectedDate {
            datePicker.date = selectedDate
        } else {
            datePicker.date = Date() // 없으면 현재 날짜와 시간으로 설정
        }
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = mode == .date ? .inline : .wheels
        }
    }
    
}
