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
    
    var symbolImageView: UIImageView = {
        let symbol = UIImageView()
        symbol.image = UIImage(systemName: "chevron.right")
        symbol.contentMode = .scaleAspectFit
        symbol.tintColor = TDStyle.color.mainTheme
        return symbol
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true
        
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(deleteButton)
        addSubview(symbolImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        symbolImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.right.equalTo(symbolImageView.snp.left).offset(0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.right.equalTo(deleteButton.snp.left).offset(-5)
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(10)
        }
    }
    
    func configureCell(title: String, detail: String? = nil, showDeleteButton: Bool = false) {
        titleLabel.text = title
        detailLabel.text = detail
        deleteButton.isHidden = !showDeleteButton
        detailLabel.textAlignment = detail != nil ? .right : .left
    }
}
