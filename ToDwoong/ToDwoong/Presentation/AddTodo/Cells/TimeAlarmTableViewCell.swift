//
//  TimeAlarmTableViewCell.swift
//  ToDwoong
//
//  Created by mirae on 3/15/24.
//

import UIKit

import SnapKit
import TodwoongDesign

class TimeAlarmTableViewCell: UITableViewCell {
    
    // MARK: - UI Properties
    
    static let identifier = "TimeAlarmTableViewCell"
    private let titleLabel = UILabel()
    private let chipStackView = UIStackView()

    public var onDeleteButtonTapped: ((_ deletedTime: String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleLabel()
        setupChipStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.text = "시간 알람"
        titleLabel.font = TDStyle.font.body(style: .regular)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(15)
        }
    }

    private func setupChipStackView() {
        contentView.addSubview(chipStackView)
        chipStackView.axis = .vertical
        chipStackView.spacing = 10
        chipStackView.distribution = .fill
        chipStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel)
        }
        chipStackView.isUserInteractionEnabled = true
    }

    func configure(with times: [String]) {
        chipStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        var currentStackView: UIStackView?
        
        if times.isEmpty {
            accessoryType = .disclosureIndicator
        } else {
            accessoryType = .none
            
            for (index, time) in times.enumerated() {
                if index % 3 == 0 || currentStackView == nil {
                    currentStackView = createNewHorizontalStackView()
                }
                
                let chipView = InfoChipView(text: time, color: TDStyle.color.lightGray, showDeleteButton: true)
                chipView.delegate = self
                currentStackView?.addArrangedSubview(chipView)
                
                chipView.snp.makeConstraints { make in
                    make.width.greaterThanOrEqualTo(chipView.intrinsicContentSize.width).priority(.high)
                }
            }
        }
    }

    private func createNewHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        chipStackView.addArrangedSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        
        return stackView
    }
}

// MARK: - InfoChipViewDelegate

extension TimeAlarmTableViewCell: InfoChipViewDelegate {
    func didTapDeleteButton(in chipView: InfoChipView) {
        guard let text = chipView.text else { return }
        onDeleteButtonTapped?(text)
    }
}
