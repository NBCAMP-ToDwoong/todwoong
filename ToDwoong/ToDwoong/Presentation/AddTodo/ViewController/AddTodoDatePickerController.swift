//
//  AddTodoDatePickerController.swift
//  ToDwoong
//
//  Created by mirae on 3/15/24.
//

import UIKit

class AddTodoDatePickerController: UIViewController {

    weak var delegate: DatePickerModalDelegate?
    
    private let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        setupDoneButton()
    }
    
    private func setupDatePicker() {
        view.backgroundColor = .white
        view.addSubview(datePicker)
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
        }
    }
    
    private func setupDoneButton() {
        let doneButton = UIButton()
        view.addSubview(doneButton)
        doneButton.setTitle("완료", for: .normal)
        doneButton.setTitleColor(.blue, for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(datePicker.snp.bottom).offset(20)
        }
    }
    
    @objc private func doneButtonTapped() {
        delegate?.didSelectDate(datePicker.date)
        dismiss(animated: true, completion: nil)
    }
}