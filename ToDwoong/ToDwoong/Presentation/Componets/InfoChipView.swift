//
//  InfoChipView.swift
//  ToDwoong
//
//  Created by mirae on 3/14/24.
//

import UIKit

import SnapKit
import TodwoongDesign

class InfoChipView: UIView {
    private let textLabel = UILabel()
    private let deleteButton = UIButton()
    
    var text: String? {
        return textLabel.text
    }

    weak var delegate: InfoChipViewDelegate?

    init(text: String, color: UIColor, showDeleteButton: Bool) {
        super.init(frame: .zero)
        setupTextLabel(text: text)
        setupDeleteButton()
        setupView(color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTextLabel(text: String) {
        textLabel.text = text
        textLabel.textColor = .black
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    private func setupDeleteButton() {
        deleteButton.setImage(UIImage(systemName: "multiply"), for: .normal)
        deleteButton.tintColor = .black
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 4).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    private func setupView(color: UIColor) {
        backgroundColor = color
        layer.cornerRadius = 3
        clipsToBounds = true
    }

    @objc private func deleteButtonTapped() {
        delegate?.didTapDeleteButton(in: self)
    }
}
