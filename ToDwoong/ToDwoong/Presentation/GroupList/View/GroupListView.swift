//
//  GroupListView.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 3/4/24.
//
import UIKit

import SnapKit

final class GroupListView: UIView {
    
    // MARK: - Properties
    let groupTableView = GroupTableView(frame: .zero, style: .insetGrouped)
    lazy var addGroupButton = AddGroupButton()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAddButton()
        setTableView()
}
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
// MARK: - UI & Layout Methods
    
    private func setAddButton() {
        addSubview(addGroupButton)
        addGroupButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
            make.trailing.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(44)
        }
    }
    
    private func setTableView() {
        addSubview(groupTableView)
        groupTableView.snp.makeConstraints { make in
            make.top.equalTo(addGroupButton.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}
