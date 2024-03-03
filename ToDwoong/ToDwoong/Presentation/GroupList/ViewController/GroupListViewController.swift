//
//  GroupListViewController.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 2/29/24.
//

import UIKit

import SnapKit

final class GroupListViewController: UIViewController {
    
    private let groupListView = GroupListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupGroupListView()
    }
    
    private func setupNavigationBar() {
        title = "카테고리"
        
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
    }
    
    private func setupGroupListView() {
        view.addSubview(groupListView)
        groupListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        groupListView.backgroundColor = .white
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapEditButton() {
        // 테이블뷰의 셀을 편집 할 수 있게 변경
    }

}
