//
//  OnboardingView.swift
//  ToDwoong
//
//  Created by 홍희곤 on 2/28/24.
//

import UIKit
import SnapKit

final class OnboardingView: UIView {
    
    //MARK: UI Properties
    
    private lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage()
        
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "위치권한 항상 허용 상태"
        
        return label
    }()
    
    lazy var requestButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.backgroundColor = .green
        
        return button
    }()
    
    //MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK: Extension

extension OnboardingView {
    private func setUI() {
        self.backgroundColor = .white
        
        [
            locationImageView,
            descriptionLabel,
            requestButton
        ].forEach{self.addSubview($0)}
        
        locationImageView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.height.equalTo(50)
            make.width.equalTo(30)
        }
        
        descriptionLabel.snp.makeConstraints{ make in
            make.top.equalTo(locationImageView.snp_bottomMargin).offset(16)
            make.centerX.equalToSuperview()
        }
        
        requestButton.snp.makeConstraints{ make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-30)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
    }
}
