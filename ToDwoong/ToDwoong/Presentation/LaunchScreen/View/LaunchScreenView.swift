//
//  LaunchScreenView.swift
//  ToDwoong
//
//  Created by 홍희곤 on 3/8/24.
//

import UIKit

import SnapKit
import TodwoongDesign

final class LaunchScreenView: UIView {
    
    // MARK: UI Properties
    
    private let launchScreenImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LaunchScreenImage")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}

// MARK: - Extension

extension LaunchScreenView {
    private func setUI() {
        backgroundColor = TDStyle.color.mainTheme
        addSubview(launchScreenImageView)
        
        launchScreenImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(self.snp.width).dividedBy(3)
        }
    }
}
