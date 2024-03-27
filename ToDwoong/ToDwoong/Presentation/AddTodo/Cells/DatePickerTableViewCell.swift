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
    static let identifier = "DatePickerCell"
    let dateLabel = UILabel()
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    var dateChipTappedHandler: (() -> Void)?
    var timeChipTappedHandler: (() -> Void)?
    var dateChipDeleteHandler: (() -> Void)?
    var timeChipDeleteHandler: (() -> Void)?
    
    var selectedDate: Date? {
        didSet {
            updateDateChip()
        }
    }
    
    var selectedTime: Date? {
        didSet {
            updateTimeChip()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let dateText = dateFormatter.string(from: selectedDate ?? Date())
        
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        let timeText = timeFormatter.string(from: selectedTime ?? Date())
        
        let dateChip = InfoChipView(text: dateText, color: TDStyle.color.lightGray, showDeleteButton: false)
        let timeChip = InfoChipView(text: timeText, color: TDStyle.color.lightGray, showDeleteButton: false)
        dateChip.removeFromSuperview()
        timeChip.removeFromSuperview()
        dateChip.delegate = self
        timeChip.delegate = self
        
        dateLabel.text = "날짜"
        dateLabel.textColor = .black

        contentView.addSubview(dateLabel)
        contentView.addSubview(dateChip)
        contentView.addSubview(timeChip)
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(30)
            make.centerY.equalTo(contentView.snp.centerY)
        }

        dateChip.snp.makeConstraints { make in
            make.trailing.equalTo(timeChip.snp.leading).offset(-8)
            make.top.equalTo(contentView.snp.top).offset(8)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
        
        timeChip.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-30)
            make.top.equalTo(contentView.snp.top).offset(8)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
        
        let dateTapGesture = UITapGestureRecognizer(target: self, action: #selector(dateChipTapped))
        dateChip.addGestureRecognizer(dateTapGesture)
        dateChip.isUserInteractionEnabled = true

        let timeTapGesture = UITapGestureRecognizer(target: self, action: #selector(timeChipTapped))
        timeChip.addGestureRecognizer(timeTapGesture)
        timeChip.isUserInteractionEnabled = true
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short

    }
    
    private func updateDateChip() {
        guard selectedDate != nil else { return }
        configure()
    }
        
    private func updateTimeChip() {
        guard selectedTime != nil else { return }
        configure()
    }

    @objc private func dateChipTapped() {
        dateChipTappedHandler?()
    }
    
    @objc private func timeChipTapped() {
        timeChipTappedHandler?()
    }
}

extension DatePickerTableViewCell: InfoChipViewDelegate {
    func didTapDeleteButton(in chipView: InfoChipView) {
        chipView.removeFromSuperview()
        accessoryType = .disclosureIndicator
    }
    
}
