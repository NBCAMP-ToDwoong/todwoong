//
//  DatePickerCollectionViewCell.swift
//  ToDwoong
//
//  Created by mirae on 3/2/24.
//

import UIKit

import SnapKit

class DatePickerCollectionViewCell: UICollectionViewCell {
    var datePicker: UIDatePicker?
    var onDateChanged: ((Date) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDatePicker()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDatePicker()
    }

    private func setupDatePicker() {
        datePicker = UIDatePicker()
        addSubview(datePicker!)
        datePicker!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker!.topAnchor.constraint(equalTo: topAnchor),
            datePicker!.bottomAnchor.constraint(equalTo: bottomAnchor),
            datePicker!.leadingAnchor.constraint(equalTo: leadingAnchor),
            datePicker!.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        datePicker?.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        onDateChanged?(sender.date)
        let formatter = DateFormatter()
        formatter.dateFormat = sender.datePickerMode == .date ? "yyyy.MM.dd" : "a HH:mm"
        let dateString = formatter.string(from: sender.date)
        print("변경 값: \(dateString)")
    }

    func configure(for mode: UIDatePicker.Mode) {
        datePicker?.datePickerMode = mode
        if #available(iOS 14, *) {
            datePicker?.preferredDatePickerStyle = mode == .date ? .inline : .wheels
        }

        // 셀이 화면에 나타날 때 현재 날짜와 시간(초기값)을 프린트합니다.
        let initialDate = datePicker?.date ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = mode == .date ? "yyyy.MM.dd" : "a HH:mm"
        let initialDateString = formatter.string(from: initialDate)
        print("초기 값: \(initialDateString)")
    }
    
}
