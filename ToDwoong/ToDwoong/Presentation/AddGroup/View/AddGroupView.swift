//
//  AddGroupView.swift
//  ToDwoong
//
//  Created by 홍희곤 on 3/5/24.
//

import UIKit

import TodwoongDesign

final class AddGroupView: UIView {
    
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
    
    private lazy var palleteButton = makePalletButton(systemImageString: "xmark.circle",
                                                      color: TDStyle.color.bgGray)
    private lazy var palleteButton1 = makePalletButton(systemImageString: "circle.fill",
                                                       color: TDStyle.color.bgRed)
    private lazy var palleteButton2 = makePalletButton(systemImageString: "circle.fill",
                                                       color: TDStyle.color.bgRed)
    private lazy var palleteButton3 = makePalletButton(systemImageString: "circle.fill",
                                                       color: TDStyle.color.bgRed)
    private lazy var palleteButton4 = makePalletButton(systemImageString: "circle.fill",
                                                       color: TDStyle.color.bgRed)
    private lazy var palleteButton5 = makePalletButton(systemImageString: "circle.fill",
                                                       color: TDStyle.color.bgRed)
    private lazy var palleteButton6 = makePalletButton(systemImageString: "circle.fill",
                                                       color: TDStyle.color.bgRed)
    private lazy var palleteButton7 = makePalletButton(systemImageString: "circle.fill",
                                                       color: TDStyle.color.bgRed)
    private lazy var palleteButton8 = makePalletButton(systemImageString: "circle.fill",
                                                       color: TDStyle.color.bgRed)
    private lazy var palleteButton9 = makePalletButton(systemImageString: "circle.fill",
                                                       color: .clear)
    
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
    private func setUI() {
        self.backgroundColor = TDStyle.color.lightGray
        
        [
            groupTextField,
            palleteStackView1,
            palleteStackView2,
            testButton
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
        
        palleteButton.snp.makeConstraints { make in
            make.height.equalTo(palleteButton.snp.width)
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
        palleteButton6.snp.makeConstraints { make in
            make.height.equalTo(palleteButton6.snp.width)
        }
        palleteButton7.snp.makeConstraints { make in
            make.height.equalTo(palleteButton7.snp.width)
        }
        palleteButton8.snp.makeConstraints { make in
            make.height.equalTo(palleteButton8.snp.width)
        }
        palleteButton9.snp.makeConstraints { make in
            make.height.equalTo(palleteButton9.snp.width)
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
