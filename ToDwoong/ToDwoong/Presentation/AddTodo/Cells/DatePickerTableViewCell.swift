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
    private let titleLabel = UILabel()
    private let dateFormatter = DateFormatter()
    
    private var dateChip: InfoChipView?
    
    var dateChipTappedHandler: (() -> Void)?
    var dateChipDeleteHandler: (() -> Void)?
    var onDateChanged: ((Date?) -> Void)?
    
    var selectedDate: Date? {
        didSet {
            updateDateChip()
            onDateChanged?(selectedDate)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureFormatters()
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        accessoryType = (selectedDate == nil) ? .disclosureIndicator : .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureFormatters() {
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd  a h:mm"
    }
    
    private func configureUI() {
        configureDateLabel()
        updateDateChip()
    }
    
    private func configureDateLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.text = "날짜"
        titleLabel.font = TDStyle.font.body(style: .regular)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
    }
    
    private func updateDateChip() {
        if let selectedDate = selectedDate {
            let dateText = dateFormatter.string(from: selectedDate)
            if dateChip == nil {
                dateChip = InfoChipView(text: dateText, color: TDStyle.color.lightGray, showDeleteButton: true)
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
    
    private func setChipConstraints() {
        dateChip?.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
            make.trailing.equalToSuperview().offset(-30)
        }
    }
    
}

// MARK: - @objc method

extension DatePickerTableViewCell {
    @objc private func dateChipTapped() {
        dateChipTappedHandler?()
    }
    
}

// MARK: - InfoChipViewDelegate

extension DatePickerTableViewCell: InfoChipViewDelegate {
    func didTapDeleteButton(in chipView: InfoChipView) {
        dateChip?.removeFromSuperview()
        dateChip = nil
        selectedDate = nil
        accessoryType = .disclosureIndicator
        
    }
    
    func resetChipsNeeded() {
        guard dateChip == nil else { return }
        let now = Date()
        selectedDate = now
        updateDateChip()
        accessoryType = .none
    }
    
}
