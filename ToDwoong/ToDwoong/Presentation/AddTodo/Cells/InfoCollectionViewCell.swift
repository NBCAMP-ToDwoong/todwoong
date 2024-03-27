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
    
    var deleteGroupAction: (() -> Void)?
    
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
        layer.masksToBounds = true
        self.clipsToBounds = true
        self.backgroundColor = .white
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
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
            make.right.equalToSuperview().offset(-10)
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
    func configureCell(title: String, detail: String? = nil, showRemoveButton: Bool = false) {
            titleLabel.text = title
            detailLabel.text = detail
            
            if let detail = detail, !detail.isEmpty {
                removeButton.isHidden = false
                symbolImageView.isHidden = true
                detailLabel.textAlignment = .right
            } else {
                removeButton.isHidden = true
                symbolImageView.isHidden = false
                detailLabel.textAlignment = .left
            }
        }
    
    func toggleRemoveButton(_ show: Bool) {
        removeButton.isHidden = !show
        symbolImageView.isHidden = show
        if show {
            detailLabel.snp.updateConstraints { make in
                make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(20)
            }
        } else {
            detailLabel.snp.updateConstraints { make in
                make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(10)
            }
        }
    }
  
}
