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
        if #available(iOS 15.0, *) {
            return super.intrinsicContentSize
        } else {
            let labelSize = titleLabel?.sizeThatFits(
                CGSize(width: CGFloat.greatestFiniteMagnitude,
                       height: CGFloat.greatestFiniteMagnitude)) ?? .zero
            let desiredWidth = labelSize.width + contentEdgeInsets.left + contentEdgeInsets.right + 10
            let desiredHeight = labelSize.height + contentEdgeInsets.top + contentEdgeInsets.bottom + 5
            return CGSize(width: desiredWidth, height: desiredHeight)
        }
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
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.title = title
            config.baseBackgroundColor = color
            config.baseForegroundColor = .black // Use for text color
            config.cornerStyle = .medium // Adjust as needed
            config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
            self.configuration = config
            self.normalBackgroundColor = color
        } else {
            setTitle(title, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 14) // Adjust font style as needed
            setTitleColor(.black, for: .normal)
            backgroundColor = color
            normalBackgroundColor = color
            layer.cornerRadius = 15
            contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        }
    }
    
    private func updateBackgroundColor() {
        if #available(iOS 15.0, *) {
            configurationUpdateHandler = { [weak self] button in
                guard let self = self else { return }
                var updatedConfig = button.configuration
                updatedConfig?.baseBackgroundColor = self.isSelectedButton 
                ? UIColor(white: 0.9, alpha: 1.0)
                : self.normalBackgroundColor
                button.configuration = updatedConfig
            }
        } else {
            backgroundColor = isSelectedButton ? UIColor(white: 0.9, alpha: 1.0) : normalBackgroundColor
        }
    }
    
    private func updateTitleColor() {
        if #available(iOS 15.0, *) {
            configurationUpdateHandler = { [weak self] button in
                guard let self = self else { return }
                var updatedConfig = button.configuration
                updatedConfig?.baseForegroundColor = self.isSelectedButton ? .white : .black
                button.configuration = updatedConfig
            }
        } else {
            setTitleColor(isSelectedButton ? .white : .black, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
