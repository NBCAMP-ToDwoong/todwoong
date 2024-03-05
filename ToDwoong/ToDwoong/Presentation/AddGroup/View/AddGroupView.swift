//
//  AddGroupView.swift
//  ToDwoong
//
//  Created by 홍희곤 on 3/5/24.
//

import UIKit

import TodwoongDesign

class AddGroupView: UIView {
    
    // MARK: - UI Properties
    
    private lazy var groupTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var palleteStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var palleteButton1 = makePalletButton(systemImageString: "x.circle",
                                                       color: TDStyle.color.bgRed)
    private lazy var palleteButton2 = makePalletButton(systemImageString: "circle.fill",
                                                       color: TDStyle.color.bgRed)
    private lazy var palleteButton3 = makePalletButton(systemImageString: "circle.fill",
                                                       color: TDStyle.color.bgRed)
    private lazy var palleteButton4 = makePalletButton(systemImageString: "circle.fill",
                                                       color: TDStyle.color.bgRed)
    private lazy var palleteButton5 = makePalletButton(systemImageString: "circle.fill",
                                                       color: TDStyle.color.bgRed)
    
    var testButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        
        return button
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

extension AddGroupView {
    func setUI() {
        self.backgroundColor = TDStyle.color.lightGray
        
        addSubview(groupTextField)
        addSubview(palleteStackView)
        [
            palleteButton1,
            palleteButton2,
            palleteButton3,
            palleteButton4,
            palleteButton5
        ].forEach { palleteStackView.addArrangedSubview($0)}
        
        addSubview(testButton)
        
        groupTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(44)
        }
        
        palleteStackView.snp.makeConstraints { make in
            make.top.equalTo(groupTextField.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        palleteButton1.snp.makeConstraints { make in
            make.height.equalTo(palleteButton1.snp.width)
        }
        palleteButton2.snp.makeConstraints { make in
            make.height.equalTo(palleteButton2.snp.width)
        }
        palleteButton3.snp.makeConstraints { make in
            make.height.equalTo(palleteButton3.snp.width)
        }
        palleteButton4.snp.makeConstraints { make in
            make.height.equalTo(palleteButton4.snp.width)
        }
        palleteButton5.snp.makeConstraints { make in
            make.height.equalTo(palleteButton5.snp.width)
        }
        
        testButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-50)
            make.width.equalTo(60)
            make.centerX.equalToSuperview()
        }
    }
    
    private func makePalletButton(systemImageString: String, color: UIColor) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: systemImageString), for: .normal)
        button.tintColor = color
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        
        return button
    }
}
