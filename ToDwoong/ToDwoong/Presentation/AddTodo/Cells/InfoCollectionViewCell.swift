//
//  InfoCollectionViewCell.swift
//  ToDwoong
//
//  Created by mirae on 3/2/24.
//

import UIKit

import SnapKit
import TodwoongDesign

class InfoCollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = TDStyle.color.bgRed
        button.isHidden = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(deleteButton)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.right.equalTo(deleteButton.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(10)
        }

        // 테두리 설정
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true
    }
    
    func configureCell(title: String, detail: String? = nil, showDeleteButton: Bool = false) {
        titleLabel.text = title
        detailLabel.text = detail
        deleteButton.isHidden = !showDeleteButton
        detailLabel.textAlignment = detail != nil ? .right : .left
    }
}
