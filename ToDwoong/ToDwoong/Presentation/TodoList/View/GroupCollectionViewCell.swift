//
//  categoryCollectionViewCell.swift
//  ToDwoong
//
//  Created by 홍희곤 on 2/29/24.
//

import UIKit

import TodwoongDesign

final class GroupCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let identifier = "categoryCollectionViewCell"
    
    // MARK: UI Properties
    
    var groupButton: TDCustomButton = {
        let button = TDButton.chip(title: "Test", backgroundColor: .yellow)

        return button
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Configure Method

extension GroupCollectionViewCell {
    func configure(data: Category) {
        groupButton.setTitle(data.title, for: .normal)
        
        if let color = data.color {
            groupButton.tintColor = UIColor(named: color)
        }
    }
}

// MARK: Extensions

extension GroupCollectionViewCell {
    func setUI() {
        contentView.addSubview(groupButton)
        
        groupButton.snp.makeConstraints {make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
