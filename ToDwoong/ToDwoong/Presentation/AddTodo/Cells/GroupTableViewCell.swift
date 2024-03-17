//
//  GroupTableViewCell.swift
//  ToDwoong
//
//  Created by mirae on 3/14/24.
//
import UIKit

import SnapKit
import TodwoongDesign

class GroupTableViewCell: UITableViewCell {
    static let identifier = "GroupTableViewCell"
    
    private let titleLabel = UILabel()
    private var chipView: InfoChipView?
    
    public var onDeleteButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.text = "그룹"
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with chipText: String?) {
        chipView?.removeFromSuperview()
        
        if let text = chipText, !text.isEmpty {
            chipView = InfoChipView(text: text, color: TDStyle.color.lightGray, showDeleteButton: true)
            guard let chipView = chipView else { return }
            addSubview(chipView)
            chipView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(30)
                make.centerY.equalToSuperview()
                make.height.equalTo(30)
            }
            accessoryType = .none
            chipView.delegate = self
        } else {
            accessoryType = .disclosureIndicator
        }
    }
}

extension GroupTableViewCell: InfoChipViewDelegate {
    func didTapDeleteButton(in chipView: InfoChipView) {
        chipView.removeFromSuperview()
        accessoryType = .disclosureIndicator
        onDeleteButtonTapped?()
    }
}
