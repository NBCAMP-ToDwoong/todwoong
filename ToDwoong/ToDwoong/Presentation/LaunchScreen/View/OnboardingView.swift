//
//  OnboardingView.swift
//  ToDwoong
//
//  Created by 홍희곤 on 2/28/24.
//

import UIKit

import SnapKit
import TodwoongDesign

final class OnboardingView: UIView {
    
    // MARK: UI Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "원활한 앱 사용을 위해 접근 권한을 허용해주세요"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = TDStyle.font.title2(style: .bold)
        
        return label
    }()
    
    private lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "OnboardingImage")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "*권한을 허용하지 않아도 서비스 이용은 가능하지만 일부 서비스가 제한될 수 있습니다."
        label.textAlignment = .center
        label.font = TDStyle.font.footnote(style: .regular)
        label.textColor = TDStyle.color.secondaryLabel
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var requestButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.backgroundColor = TDStyle.color.mainTheme
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: Extension

extension OnboardingView {
    private func setUI() {
        self.backgroundColor = .white
        
        [
            titleLabel,
            locationImageView,
            descriptionLabel,
            requestButton
        ].forEach{self.addSubview($0)}
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(self.snp.width).dividedBy(1.5)
            make.centerY.equalToSuperview().dividedBy(2)
        }
        
        locationImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().dividedBy(1.2)
            make.width.height.equalTo(self.snp.width).dividedBy(3)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(self.snp.width).dividedBy(1.5)
            make.bottom.equalTo(requestButton.snp.top).offset(-16)
        }
        
        requestButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().dividedBy(1.1)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
    }
}
