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
        var config = UIButton.Configuration.plain()
        
        config.baseForegroundColor = TDStyle.color.mainTheme
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
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }

        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 45, weight: .light, scale: .large)
        let symbolImage = UIImage(systemName: "plus.circle.fill", withConfiguration: symbolConfig)
        button.setImage(symbolImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
    }
    
}

// MARK: - @objc method

extension FloatingButton {
    @objc private func buttonTapped() {
        floatingButtonTapped?()
    }
}
