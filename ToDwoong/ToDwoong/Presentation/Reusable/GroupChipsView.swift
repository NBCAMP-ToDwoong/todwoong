//
//  GroupChipsView.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 3/14/24.
//

import UIKit

import SnapKit
import TodwoongDesign

class GroupChipsView: UIView {
    
    // MARK: - Properties
    
    var selectedGroupButton: TDCustomButton?
    var onAllGroupButtonTapped: (() -> Void)?
    
    // MARK: - UI Components
    
    lazy var groupScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var groupStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    lazy var groupListButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        
        let image = UIImage(systemName: "line.3.horizontal")
        button.setImage(image, for: .normal)
        
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    lazy var allGroupButton: TDCustomButton = {
        let button = TDCustomButton(frame: .zero, 
                                    type: .chip,
                                    title: "전체", 
                                    backgroundColor: TDStyle.color.mainTheme)
        return button
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        
        allGroupButton.tag = -1
        allGroupButton.addTarget(self, action: #selector(allGroupButtonTapped), for: .touchUpInside)
        
        selectGroupButton(allGroupButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setView() {
        addSubview(groupListButton)
        addSubview(allGroupButton)
        addSubview(groupScrollView)
        groupScrollView.addSubview(groupStackView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        groupListButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(groupListButton.snp.height)
        }
        
        allGroupButton.snp.makeConstraints { make in
            make.leading.equalTo(groupListButton.snp.trailing).offset(8)
            make.centerY.equalTo(groupListButton)
        }
        
        groupScrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(allGroupButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
        }
        
        groupStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    
    func addGroupChip(group: CategoryModel, action: Selector, target: Any?) {
        let chipButton = TDCustomButton(frame: .zero, type: .chip,
                                        title: group.title,
                                        backgroundColor: UIColor(hex: group.color ?? "#D1FADF"))
        chipButton.tag = Int(group.indexNumber ?? 0)
        chipButton.addTarget(target, action: action, for: .touchUpInside)
        chipButton.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        groupStackView.addArrangedSubview(chipButton)
    }
    
    func selectGroupButton(_ button: TDCustomButton) {
        if let previousSelectedButton = selectedGroupButton {
            previousSelectedButton.alpha = 0.5
            previousSelectedButton.isSelected = false
        }
        
        selectedGroupButton = button
        selectedGroupButton?.isSelected = true
        
        if button == allGroupButton {
            allGroupButton.alpha = 1.0
            groupStackView.arrangedSubviews.forEach { subview in
                if let chipButton = subview as? TDCustomButton {
                    chipButton.alpha = 0.5
                    chipButton.isSelected = false
                }
            }
        } else {
            button.alpha = 1.0
            allGroupButton.alpha = 0.5
            allGroupButton.isSelected = false
            groupStackView.arrangedSubviews.forEach { subview in
                if let chipButton = subview as? TDCustomButton, chipButton != button {
                    chipButton.alpha = 0.5
                    chipButton.isSelected = false
                }
            }
        }
    }
    
    // MARK: - Action Methods
    
    @objc func allGroupButtonTapped() {
        onAllGroupButtonTapped?()
    }
}
