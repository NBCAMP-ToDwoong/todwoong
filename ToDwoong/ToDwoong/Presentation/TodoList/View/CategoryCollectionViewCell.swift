//
//  categoryCollectionViewCell.swift
//  ToDwoong
//
//  Created by 홍희곤 on 2/29/24.
//

import UIKit

import TodwoongDesign

final class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let identifier = "categoryCollectionViewCell"
    
    // MARK: UI Properties
    
    var categoryButton: TDCustomButton = {
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

extension CategoryCollectionViewCell {
    func configure(setTitle: String) {
        categoryButton.setTitle(setTitle, for: .normal)
    }
}

// MARK: Extensions

extension CategoryCollectionViewCell {
    func setUI() {
        contentView.addSubview(categoryButton)
        
        categoryButton.snp.makeConstraints {make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
