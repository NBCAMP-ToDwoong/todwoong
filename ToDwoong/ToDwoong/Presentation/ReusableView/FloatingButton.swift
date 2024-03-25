//
//  FloatingButton.swift
//  ToDwoong
//
//  Created by mirae on 3/25/24.
//

import UIKit

import SnapKit
import TodwoongDesign

class FloatingButton: UIView {
    
    // MARK: - UI Properties
    
    var floatingButtonTapped: (() -> Void)?
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        
        config.baseBackgroundColor = TDStyle.color.mainTheme
        config.image = UIImage(systemName: "plus")
        config.imagePadding = 10
        config.cornerStyle = .fixed
        config.background.cornerRadius = 30
        config.baseForegroundColor = UIColor.white
        
        button.configuration = config
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFloatingButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupFloatingButton() {
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

// MARK: - @objc method

extension FloatingButton {
    @objc private func buttonTapped() {
        floatingButtonTapped?()
    }
}
