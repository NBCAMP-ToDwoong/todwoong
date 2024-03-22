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
        get {
            return textLabel.text
        }
        set(newText) {
            textLabel.text = newText
        }
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
        addSubview(textLabel)
        textLabel.text = text
        textLabel.textColor = .black
        textLabel.font = TDStyle.font.body(style: .regular)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    private func setupDeleteButton() {
        let button = UIButton()
        addSubview(button)
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 0).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -0).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
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
