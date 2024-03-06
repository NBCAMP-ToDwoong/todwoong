//
//  InfoCollectionViewCell.swift
//  ToDwoong
//
//  Created by mirae on 3/2/24.
//

import UIKit

import SnapKit
import TodwoongDesign

final class InfoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemRed
        button.isHidden = true
        return button
    }()
    
    var symbolImageView: UIImageView = {
        let symbol = UIImageView()
        symbol.image = UIImage(systemName: "chevron.right")
        symbol.contentMode = .scaleAspectFit
        symbol.tintColor = .black
        return symbol
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [titleLabel, detailLabel, removeButton, symbolImageView].forEach { subview in
            addSubview(subview)
        }
    }
    
}

// MARK: - setView

extension InfoCollectionViewCell {
    private func setView() {
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true
        
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        symbolImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        removeButton.snp.makeConstraints { make in
            make.right.equalTo(symbolImageView.snp.left).offset(0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.right.equalTo(removeButton.snp.left).offset(-5)
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(10)
        }
    }
    
}

// MARK: - configureCell

extension InfoCollectionViewCell {
    func configureCell(title: String, detail: String? = nil, showremoveButton: Bool = false) {
        titleLabel.text = title
        detailLabel.text = detail
        removeButton.isHidden = !showremoveButton
        detailLabel.textAlignment = detail != nil ? .right : .left
    }
    
}
