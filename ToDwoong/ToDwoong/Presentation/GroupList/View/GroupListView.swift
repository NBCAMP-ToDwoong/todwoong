//
//  GroupListView.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 3/4/24.
//

import CoreData
import UIKit

import SnapKit
import TodwoongDesign

final class GroupListView: UIView {
    
    // MARK: - Properties
    
    private let normalCellIdentifier = "NormalGroupCell"
    private let editCellIdentifier = "EditGroupCell"
    private var categories: [Category] = []
    
    // MARK: - UI Properties
    
    private let tableView: ContentSizedTableView = {
        let tableView = ContentSizedTableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.title = "그룹 추가"
            config.baseBackgroundColor = .white
            config.baseForegroundColor = UIColor.systemGray3
            config.cornerStyle = .medium
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
            config.imagePlacement = .leading
            config.imagePadding = 8
            
            let plusIcon = UIImage(systemName: "plus")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            config.image = plusIcon
            
            button.configuration = config
            button.contentHorizontalAlignment = .leading
        } else {
            button.setTitle("그룹 추가", for: .normal)
            button.backgroundColor = .white
            button.setTitleColor(UIColor.systemGray3, for: .normal)
            button.layer.cornerRadius = 8
            button.contentHorizontalAlignment = .left
            let plusIcon = UIImage(systemName: "plus")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            button.setImage(plusIcon, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        }
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAddButton()
        setTableView()
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureAddButtonAction(target: Any, action: Selector) {
        addButton.addTarget(target, action: action, for: .touchUpInside)
    }
}

// MARK: - UI & Layout Extension

extension GroupListView {
    private func setAddButton() {
        addSubview(addButton)
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
            make.trailing.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(44)
        }
        
        addButton.titleLabel?.font = TDStyle.font.body(style: .regular)
    }
    
    private func setTableView() {
        addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NormalGroupListTableViewCell.self, forCellReuseIdentifier: normalCellIdentifier)
        tableView.register(EditGroupListTableViewCell.self, forCellReuseIdentifier: editCellIdentifier)
        
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func reloadData() {
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = CoreDataManager.shared.readCategories()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

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
        let movedCategory = categories.remove(at: sourceIndexPath.row)
        categories.insert(movedCategory, at: destinationIndexPath.row)

        for (index, category) in categories.enumerated() {
            category.indexNumber = Int32(index)
        }

        let context = CoreDataManager.shared.context
        do {
            try context.save()
        } catch {
            print("Core Data 컨텍스트 저장 실패: \(error)")
        }
    }
}

// MARK: - UITableViewDataSource

extension GroupListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.isEditing {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: editCellIdentifier,
                                                           for: indexPath) as? EditGroupListTableViewCell else {
                fatalError("셀을 가져오는데 실패하였습니다.")
            }
            
            let category = categories[indexPath.row]
            cell.titleLabel.text = category.title
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: normalCellIdentifier,
                                                           for: indexPath) as? NormalGroupListTableViewCell else {
                fatalError("셀을 가져오는데 실패하였습니다.")
            }
            
            let category = categories[indexPath.row]
            cell.configureWithCategory(category)
            
            return cell
        }
    }
}

// MARK: Extension

extension GroupListView {
    private func editCategory(at indexPath: IndexPath) {
        // FIXME: 편집(톱니바귀) 설정을 눌렀을 때의 메서드를 작성. 모달창을 띄워 카테고리를 Update하는 메서드
    }
}

extension GroupListView {
    private func deleteCategory(at indexPath: IndexPath) {
        let categoryToDelete = categories[indexPath.row]
        CoreDataManager.shared.deleteCategory(category: categoryToDelete)
        categories.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func setEditingMode(_ isEditing: Bool) {
        tableView.setEditing(isEditing, animated: true)
        tableView.reloadData()
        tableView.allowsSelectionDuringEditing = isEditing // 셀을 이동하는 동안에도 선택할 수 있도록 설정
    }
}
