//
//  categoryCollectionViewCell.swift
//  ToDwoong
//
//  Created by 홍희곤 on 2/29/24.
//

import UIKit

import TodwoongDesign

final class GroupCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var buttonAction: ((UIButton) -> Void) = { _ in }
    static let identifier = "categoryCollectionViewCell"
    
    // MARK: - UI Properties
    
    var groupButton: UIButton = {
        let button = TDButton.chip(title: "전체", backgroundColor: TDStyle.color.mainTheme)
        button.addTarget(self, action: #selector(groupButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Method

extension GroupCollectionViewCell {
    func configure(data: Category) {
        
        guard let title = data.title else { return }
        
        if let color = data.color {
            let button = TDButton.chip(title: title, backgroundColor: UIColor(hex: color))
            
            groupButton.configuration = button.configuration
        }
    }
}

// MARK: - @objc Method

extension GroupCollectionViewCell {
    @objc func groupButtonTapped(_ sender: UIButton) {
        buttonAction(sender)
    }
}

// MARK: - Extensions

extension GroupCollectionViewCell {
    func setUI() {
        contentView.addSubview(groupButton)
        
        groupButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
