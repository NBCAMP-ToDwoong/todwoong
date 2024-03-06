//
//  DateTimeOptionCell.swift
//  ToDwoong
//
//  Created by mirae on 3/2/24.
//

import UIKit

import SnapKit
import TodwoongDesign

final class DateTimeOptionCell: UICollectionViewCell {
    
    // MARK: UI Properties
    
    var removeButtonAction: (() -> Void)?
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    var infoLabelContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = TDStyle.color.bgGray
        return view
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = TDStyle.font.body(style: .regular)
        return label
    }()
    
    lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
        setInfo(labelText: "Title", infoText: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: setView

extension DateTimeOptionCell {
    private func setView() {
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.black.cgColor
        
        [titleLabel, infoLabelContainer, removeButton].forEach { subview in
            addSubview(subview)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
        }
        
        infoLabelContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        infoLabelContainer.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
        
        addSubview(removeButton)
        removeButton.snp.makeConstraints { make in
            make.left.equalTo(infoLabelContainer.snp.right).offset(10)
            make.centerY.equalTo(infoLabelContainer.snp.centerY)
            make.width.height.equalTo(20)
        }
    }
}

// MARK: setInfo

extension DateTimeOptionCell {
    func setInfo(labelText: String, infoText: String?) {
        titleLabel.text = labelText
        
        if let infoText = infoText, !infoText.isEmpty {
            infoLabel.text = infoText
            showInfoAndAdjustLayout()
        } else {
            hideInfoAndAdjustLayout()
        }
    }
}

// MARK: Heper Functions

extension DateTimeOptionCell {
    private func adjustLayoutForEmptyInfo() {
        titleLabel.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    private func adjustLayoutForInfo() {
        titleLabel.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview().offset(-20)
        }
        infoLabelContainer.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
    }
    
    private func showInfoAndAdjustLayout() {
        infoLabel.isHidden = false
        infoLabelContainer.isHidden = false
        removeButton.isHidden = false
        adjustLayoutForInfo()
    }
    
    private func hideInfoAndAdjustLayout() {
        infoLabel.text = nil
        infoLabel.isHidden = true
        infoLabelContainer.isHidden = true
        removeButton.isHidden = true
        adjustLayoutForEmptyInfo()
        
    }
}

// MARK: @objc

extension DateTimeOptionCell {
    @objc private func removeButtonTapped() {
        removeButtonAction?()
        hideInfoAndAdjustLayout()
    }
}
