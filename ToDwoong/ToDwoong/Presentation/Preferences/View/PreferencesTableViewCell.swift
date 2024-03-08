//
//  PreferencesTableViewCell.swift
//  ToDwoong
//
//  Created by 홍희곤 on 3/8/24.
//

import UIKit

import TodwoongDesign

class PreferencesTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static var identifier = "PreferencesTableViewCellIdentifier"
    
    // MARK: - UI Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        
        return label
    }()
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = TDStyle.color.bgGray
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Method

extension PreferencesTableViewCell {
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    private func setUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        [titleLabel, chevronImageView].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            make.width.equalTo(chevronImageView.snp.height).dividedBy(2)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
