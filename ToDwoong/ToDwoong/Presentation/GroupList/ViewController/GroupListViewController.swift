//
//  GroupListViewController.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 3/4/24.
//

import UIKit

import SnapKit
import TodwoongDesign

final class GroupListViewController: UIViewController {
    
    private let groupListView = GroupListView()
    private var isEditingMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setGroupListView()
        
        groupListView.loadCategories()
        groupListView.configureAddButtonAction(target: self, action: #selector(addCategoryButtonTapped))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dataUpdated(_:)),
            name: .GroupDataUpdatedNotification,
            object: nil)
    }
    
    @objc func dataUpdated(_ notification: Notification) {
        groupListView.loadCategories()
    }
    
    private func setNavigationBar() {
        title = "그룹"
        
        let leftBarButtonItem = UIBarButtonItem(
            title: "< Back",
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(
            title: "편집",
            style: .plain,
            target: self,
            action: #selector(didTapEditButton)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        // 네비게이션 색상 설정
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func setGroupListView() {
        view.addSubview(groupListView)
        groupListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
        groupListView.backgroundColor = TDStyle.color.lightGray
    }
    
    // MARK: - Objc
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapEditButton() {
        isEditingMode.toggle()
        groupListView.setEditingMode(isEditingMode)
        
        navigationItem.rightBarButtonItem?.title = isEditingMode ? "완료" : "편집"
    }

    @objc private func addCategoryButtonTapped() {
        let viewController = AddGroupViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}
