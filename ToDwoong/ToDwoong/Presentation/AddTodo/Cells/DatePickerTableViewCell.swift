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
    
    var selectedDate: Date? {
        didSet { updateDateChip() }
    }
    
    var selectedTime: Date? {
        didSet { updateTimeChip() }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureFormatters()
        configureUI()
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
        configureTimeChip()
        configureDateChip()
    }
    
    private func configureDateLabel() {
        dateLabel.text = "날짜"
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
    }
    
    private func configureDateChip() {
        guard dateChip == nil else { return }
        
        let dateText = selectedDate.map { dateFormatter.string(from: $0) } ?? ""
        let chip = InfoChipView(text: dateText, color: TDStyle.color.lightGray, showDeleteButton: true)
        chip.tag = 1
        chip.delegate = self
        contentView.addSubview(chip)
        chip.snp.makeConstraints { make in
            make.trailing.equalTo(timeChip?.snp.leading ?? contentView.snp.trailing).offset(-8)
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
        }
        dateChip = chip
    }
    
    private func configureTimeChip() {
        guard timeChip == nil else { return }
        
        let timeText = selectedTime.map { timeFormatter.string(from: $0) } ?? ""
        let chip = InfoChipView(text: timeText, color: TDStyle.color.lightGray, showDeleteButton: true)
        chip.tag = 2
        chip.delegate = self
        contentView.addSubview(chip)
        chip.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
        }
        timeChip = chip
    }
    
    private func updateDateChip() {
        guard let selectedDate = selectedDate else { return }
        dateChip?.text = dateFormatter.string(from: selectedDate)
    }

    private func updateTimeChip() {
        guard let selectedTime = selectedTime else { return }
        timeChip?.text = timeFormatter.string(from: selectedTime)
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
            timeChip?.removeFromSuperview()
            timeChip = nil
            accessoryType = .disclosureIndicator
        } else if chipView.tag == 2 {
            timeChip?.removeFromSuperview()
            timeChip = nil
            dateChip?.snp.remakeConstraints { make in
                make.trailing.equalToSuperview().offset(-30)
                make.top.equalToSuperview().offset(8)
                make.bottom.equalToSuperview().offset(-8)
            }
            accessoryType = .none
        }
    }
    
    func resetDateAndTimeChipsIfNeeded() {
        guard dateChip == nil, timeChip == nil else { return }

        // 현재 날짜와 시간으로 설정
        let now = Date()
        selectedDate = now
        selectedTime = now
        
        // 날짜와 시간 칩 다시 생성
        configureTimeChip()
        configureDateChip()
        
        // 액세서리 타입 업데이트
        accessoryType = .none
    }
}
