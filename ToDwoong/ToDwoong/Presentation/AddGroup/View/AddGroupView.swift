//
//  AddGroupView.swift
//  ToDwoong
//
//  Created by 홍희곤 on 3/5/24.
//

import UIKit

import TodwoongDesign

final class AddGroupView: UIView {
    
    // MARK: - Properties
    
    var buttonTapped: (UIButton) -> () = { button in }
    
    // MARK: - UI Properties
    
    lazy var groupTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var palleteStackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var palleteStackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    lazy var palleteButton: UIButton = makePalletButton(systemImageString: "xmark.circle",
                                                        color: TDStyle.color.bgGray)
    lazy var palleteButton1 = makePalletButton(systemImageString: "circle.fill",
                                               color: TDStyle.color.bgGray)
    lazy var palleteButton2 = makePalletButton(systemImageString: "circle.fill",
                                               color: TDStyle.color.bgRed)
    lazy var palleteButton3 = makePalletButton(systemImageString: "circle.fill",
                                               color: TDStyle.color.bgOrange)
    lazy var palleteButton4 = makePalletButton(systemImageString: "circle.fill",
                                               color: TDStyle.color.bgYellow)
    lazy var palleteButton5 = makePalletButton(systemImageString: "circle.fill",
                                               color: TDStyle.color.bgGreen)
    lazy var palleteButton6 = makePalletButton(systemImageString: "circle.fill",
                                               color: TDStyle.color.bgBlue)
    lazy var palleteButton7 = makePalletButton(systemImageString: "circle.fill",
                                               color: TDStyle.color.bgPurple)
    lazy var palleteButton8: UIButton = {
        let button = makePalletButton(systemImageString: "circle.fill",
                         color: .clear)
        button.isEnabled = false
        
        return button
    }()
    lazy var palleteButton9 = {
        let button = makePalletButton(systemImageString: "circle.fill",
                         color: .clear)
        button.isEnabled = false
        
        return button
    }()
    
    var checkMarkImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(systemName: "checkmark")
        imageView.isHidden = true
        imageView.tintColor = .white
        
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

// MARK: - @objc Method

extension AddGroupView {
    @objc func palleteButtonTapped(sender: UIButton) {
        buttonTapped(sender)
    }
}

// MARK: - Extension

extension AddGroupView {
    private func setUI() {
        self.backgroundColor = TDStyle.color.lightGray
        
        [
            groupTextField,
            palleteStackView1,
            palleteStackView2,
            checkMarkImageView
        ].forEach { addSubview($0) }
        
        [
            palleteButton,
            palleteButton1,
            palleteButton2,
            palleteButton3,
            palleteButton4,
        ].forEach { palleteStackView1.addArrangedSubview($0) }
        
        [
            palleteButton5,
            palleteButton6,
            palleteButton7,
            palleteButton8,
            palleteButton9
        ].forEach { palleteStackView2.addArrangedSubview($0) }
        
        groupTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(44)
        }
        
        palleteStackView1.snp.makeConstraints { make in
            make.top.equalTo(groupTextField.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        palleteStackView2.snp.makeConstraints { make in
            make.top.equalTo(palleteStackView1.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        let buttons = [palleteButton, palleteButton1, palleteButton2, 
                       palleteButton3, palleteButton4, palleteButton5,
                       palleteButton6, palleteButton7, palleteButton8, palleteButton9
        ]
        
        for button in buttons {
            button.snp.makeConstraints { make in
                make.height.equalTo(button.snp.width)
            }
        }
    }
    
    private func makePalletButton(systemImageString: String, color: UIColor) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: systemImageString), for: .normal)
        button.tintColor = color
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.addTarget(self, action: #selector(palleteButtonTapped), for: .touchUpInside)
        
        return button
    }
}
