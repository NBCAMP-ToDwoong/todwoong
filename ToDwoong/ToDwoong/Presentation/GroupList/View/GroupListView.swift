//
//  GroupListView.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 3/4/24.
//

import UIKit

import SnapKit
import TodwoongDesign

final class GroupListView: UIView {
    
    // MARK: - Properties
    
    private let tableView: ContentSizedTableView = {
        let tableView = ContentSizedTableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("그룹 추가", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor.systemGray3, for: .normal)
        button.layer.cornerRadius = 8
        if var plusIcon = UIImage(systemName: "plus") {
            let iconSize = CGSize(width: 15, height: 15)
            UIGraphicsBeginImageContextWithOptions(iconSize, false, 0.0)
            plusIcon.draw(in: CGRect(origin: .zero, size: iconSize))
            plusIcon = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
            UIGraphicsEndImageContext()

            let tintColor = UIColor.systemGray3
            plusIcon = plusIcon.withTintColor(tintColor)

            button.setImage(plusIcon, for: .normal)
        }
        return button
    }()
    
    private let normalCellIdentifier = "NormalGroupCell"
    private let editCellIdentifier = "EditGroupCell"
    
    private var dummyCategories: [String] = ["밥먹기", "운동가기", "씻기", "ㅁㄴㅇ", "밥먹기", "운동가기", "씻기"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTableView()
        setupAddButton()
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setTableView()
        setupAddButton()
        reloadData()
    }
    
    private func setTableView() {
        addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NormalGroupListTableViewCell.self, forCellReuseIdentifier: normalCellIdentifier)
        tableView.register(EditGroupListTableViewCell.self, forCellReuseIdentifier: editCellIdentifier)
        
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
    private func setupAddButton() {
        addSubview(addButton)
        
        addButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(135)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.width.equalTo(355)
        }
        
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -200, bottom: 0, right: 0)
        addButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -230, bottom: 0, right: 0)
    }

    private func reloadData() {
        tableView.reloadData()
    }
}

// MARK: UITableViewDelegate

extension GroupListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.deleteCategory(at: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            self.editCategory(at: indexPath)
            completion(true)
        }
        editAction.image = UIImage(systemName: "gear")
        editAction.backgroundColor = UIColor.orange
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        func tableView(_ tableView: UITableView,
                       moveRowAt sourceIndexPath: IndexPath,
                       to destinationIndexPath: IndexPath) {
            let movedCategory = dummyCategories.remove(at: sourceIndexPath.row)
            dummyCategories.insert(movedCategory, at: destinationIndexPath.row)
        }
}

// MARK: UITableViewDataSource

extension GroupListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.isEditing {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: editCellIdentifier,
                                                           for: indexPath) as? EditGroupListTableViewCell else {
                fatalError("셀을 가져오는데 실패하였습니다.")
            }
            let category = dummyCategories[indexPath.row]
            cell.titleLabel.text = category
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: normalCellIdentifier,
                                                           for: indexPath) as? NormalGroupListTableViewCell else {
                fatalError("셀을 가져오는데 실패하였습니다.")
            }
            let category = dummyCategories[indexPath.row]
            cell.titleLabel.text = category
            
            return cell
        }
    }
}

// MARK: Extension

extension GroupListView {
    private func editCategory(at indexPath: IndexPath) {
        // FIXME: 톱니바귀 설정을 눌렀을 때의 메서드를 작성
    }
}

extension GroupListView {
    private func deleteCategory(at indexPath: IndexPath) {
        dummyCategories.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func setEditingMode(_ isEditing: Bool) {
        tableView.setEditing(isEditing, animated: true)
        tableView.reloadData()
        tableView.allowsSelectionDuringEditing = isEditing // 셀을 이동하는 동안에도 선택할 수 있도록 설정
    }
}
