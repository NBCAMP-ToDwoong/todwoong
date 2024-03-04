//
//  InfoCollectionViewCell.swift
//  ToDwoong
//
//  Created by mirae on 3/2/24.
//

import UIKit

import SnapKit

class InfoCollectionViewCell: UICollectionViewCell {
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.black.cgColor
    }
}
