//
//  TitleCollectionViewCell.swift
//  ToDwoong
//
//  Created by mirae on 3/2/24.
//

import UIKit

import SnapKit

final class TitleCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    // - MARK: UI Properties
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목"
        return textField
    }()
    
    weak var delegate: TitleCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - setView

extension TitleCollectionViewCell {
    func setView() {
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true
    }
}

// MARK: - textFieldDidEndEditing

extension TitleCollectionViewCell {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.titleCellDidEndEditing(textField.text)
    }
}
