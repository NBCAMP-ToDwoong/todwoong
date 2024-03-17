//
//  AddTodoDatePickerController.swift
//  ToDwoong
//
//  Created by mirae on 3/15/24.
//

import UIKit

import SnapKit
import TodwoongDesign

class AddTodoDatePickerController: UIViewController {
    var selectedDate: Date?
    weak var delegate: DatePickerModalDelegate?
    private let datePicker = UIDatePicker()
    
    private lazy var timeNotificationButton: UIButton = {
        var config = UIButton.Configuration.plain()
        
        config.title = "날짜 선택"
        config.baseForegroundColor = TDStyle.color.mainDarkTheme
        config.baseBackgroundColor = .clear
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: TDStyle.font.body(style: .bold)
        ]
        config.attributedTitle = AttributedString("날짜 선택", attributes: AttributeContainer(attributes))
        
        let button = UIButton(configuration: config, primaryAction: nil)
        
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        createNotificationButton(title: "저장", method: #selector(saveDate), color: .systemBlue)
    }()
    
    private func createNotificationButton(title: String,
                                          method: Selector,
                                          color: UIColor? = TDStyle.color.primaryLabel
    ) -> UIButton {
        var config = UIButton.Configuration.plain()
        
        config.title = title
        config.baseForegroundColor = color
        config.baseBackgroundColor = .clear
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: TDStyle.font.body(style: .regular)
        ]
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer(attributes))
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.addTarget(self, action: method, for: .touchUpInside)
        
        return button
    }
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        if let selectedDate = selectedDate {
            datePicker.setDate(selectedDate, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDatePicker()
        configureModalStyle()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        [timeNotificationButton, saveButton, separatorLine, datePicker].forEach { view.addSubview($0) }
        
        timeNotificationButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(10)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(15)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(0.5)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(20)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func configureModalStyle() {
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
    }
    
}

// MARK: - @objc method

extension AddTodoDatePickerController {
    @objc private func saveDate() {
        delegate?.didSelectDate(datePicker.date)
        dismiss(animated: true, completion: nil)
    }
    
}
