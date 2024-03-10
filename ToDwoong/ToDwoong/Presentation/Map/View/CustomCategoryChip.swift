//
//  CustomCategoryChip.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 3/10/24.
//

import UIKit

import TodwoongDesign

class CategoryChipButton: UIButton {
    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
        let desiredWidth = labelSize.width + contentEdgeInsets.left + contentEdgeInsets.right + 10
        let desiredHeight = labelSize.height + contentEdgeInsets.top + contentEdgeInsets.bottom + 5
        return CGSize(width: desiredWidth, height: desiredHeight)
    }
    
    var isSelectedButton: Bool = false {
        didSet {
            updateBackgroundColor()
            updateTitleColor()
        }
    }
    
    private var normalBackgroundColor: UIColor?
    
    init(title: String, color: UIColor) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = TDStyle.font.body(style: .regular)
        setTitleColor(.black, for: .normal)
        backgroundColor = color
        normalBackgroundColor = color
        layer.cornerRadius = 15
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    }
    
    private func updateBackgroundColor() {
        backgroundColor = isSelectedButton ? UIColor(white: 0.9, alpha: 1.0) : normalBackgroundColor
    }
    
    private func updateTitleColor() {
        setTitleColor(isSelectedButton ? .white : .black, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
