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
    private var deleteButton: UIButton?

    var text: String? {
        return textLabel.text
    }

    weak var delegate: InfoChipViewDelegate?

    init(text: String, color: UIColor, showDeleteButton: Bool) {
        super.init(frame: .zero)
        setupTextLabel(text: text)
        setupView(color: color)

        if showDeleteButton {
            setupDeleteButton()
        } else {
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        }
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
        let button = UIButton()
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 10).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.deleteButton = button
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
