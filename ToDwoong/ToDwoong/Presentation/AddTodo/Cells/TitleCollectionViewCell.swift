//
//  TitleCollectionViewCell.swift
//  ToDwoong
//
//  Created by mirae on 3/2/24.
//

import UIKit

import SnapKit

class TitleCollectionViewCell: UICollectionViewCell {
    var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목"
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView() {
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.black.cgColor
    }
    
}