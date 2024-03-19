//
//  DatePickerTableViewCell.swift
//  ToDwoong
//
//  Created by mirae on 3/15/24.
//

import UIKit

import SnapKit
import TodwoongDesign

class DatePickerTableViewCell: UITableViewCell {
    
    // MARK: - UI Properties
    
    static let identifier = "DatePickerCell"
    private let dateLabel = UILabel()
    private let dateFormatter = DateFormatter()
    private let timeFormatter = DateFormatter()
    
    private var dateChip: InfoChipView?
    private var timeChip: InfoChipView?
    
    var dateChipTappedHandler: (() -> Void)?
    var timeChipTappedHandler: (() -> Void)?
    var dateChipDeleteHandler: (() -> Void)?
    var timeChipDeleteHandler: (() -> Void)?
    var onDateChanged: ((Date?) -> Void)?
    var onTimeChanged: ((Date?) -> Void)?
    
    var selectedDate: Date? {
        didSet {
            updateDateChip()
            onDateChanged?(selectedDate)
        }
    }

    var selectedTime: Date? {
        didSet {
            updateTimeChip()
            onTimeChanged?(selectedTime)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureFormatters()
        configureUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        accessoryType = (selectedDate == nil && selectedTime == nil) ? .disclosureIndicator : .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureFormatters() {
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        timeFormatter.locale = Locale(identifier: "ko_KR")
        timeFormatter.dateFormat = "a h:mm"
    }
    
    private func configureUI() {
        configureDateLabel()
        updateDateChip()
        updateTimeChip()
    }
    
    private func configureDateLabel() {
        dateLabel.text = "날짜"
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
    }
    
    private func updateDateChip() {
        if let selectedDate = selectedDate {
            let dateText = dateFormatter.string(from: selectedDate)
            if dateChip == nil {
                dateChip = InfoChipView(text: dateText, color: TDStyle.color.lightGray, showDeleteButton: true)
                dateChip?.tag = 1
                dateChip?.delegate = self
                contentView.addSubview(dateChip!)
                let dateTapGesture = UITapGestureRecognizer(target: self, action: #selector(dateChipTapped))
                dateChip?.addGestureRecognizer(dateTapGesture)
                dateChip?.isUserInteractionEnabled = true
            }
            dateChip?.text = dateText
        } else {
            dateChip?.removeFromSuperview()
            dateChip = nil
        }
        setChipConstraints()
    }

    private func updateTimeChip() {
        if let selectedTime = selectedTime {
            let timeText = timeFormatter.string(from: selectedTime)
            if timeChip == nil {
                timeChip = InfoChipView(text: timeText, color: TDStyle.color.lightGray, showDeleteButton: true)
                timeChip?.tag = 2
                timeChip?.delegate = self
                contentView.addSubview(timeChip!)
                let timeTapGesture = UITapGestureRecognizer(target: self, action: #selector(timeChipTapped))
                timeChip?.addGestureRecognizer(timeTapGesture)
                timeChip?.isUserInteractionEnabled = true
            }
            timeChip?.text = timeText
        } else {
            timeChip?.removeFromSuperview()
            timeChip = nil
        }
        setChipConstraints()
    }

    private func setChipConstraints() {
        timeChip?.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
        }
        
        dateChip?.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
            if let timeChip = self.timeChip {
                make.trailing.equalTo(timeChip.snp.leading).offset(-8)
            } else {
                make.trailing.equalToSuperview().offset(-30)
            }
        }
    }

}

// MARK: - @objc method

extension DatePickerTableViewCell {
    @objc private func dateChipTapped() {
        dateChipTappedHandler?()
    }
    
    @objc private func timeChipTapped() {
        timeChipTappedHandler?()
    }
    
}

// MARK: - InfoChipViewDelegate

extension DatePickerTableViewCell: InfoChipViewDelegate {
    func didTapDeleteButton(in chipView: InfoChipView) {
        if chipView.tag == 1 {
            dateChip?.removeFromSuperview()
            dateChip = nil
            selectedDate = nil
            timeChip?.removeFromSuperview()
            timeChip = nil
            selectedTime = nil
            accessoryType = .disclosureIndicator
        } else if chipView.tag == 2 {
            timeChip?.removeFromSuperview()
            timeChip = nil
            selectedTime = nil
            dateChip?.snp.remakeConstraints { make in
                make.trailing.equalToSuperview().offset(-30)
                make.centerY.equalToSuperview()
                make.height.equalTo(32)
            }
            accessoryType = .none
        }
    }
    
    func resetChipsNeeded() {
        guard dateChip == nil, timeChip == nil else { return }
        let now = Date()
        selectedDate = now
        selectedTime = now
        
        updateDateChip()
        updateTimeChip()
        
        accessoryType = .none
    }
    
}
