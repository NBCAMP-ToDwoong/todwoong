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
    
    // MARK: - Properties
    
    private let groupListView = GroupListView()
    private var isEditingMode = false
    private var categories: [Category] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setGroupListView()
        loadCategories()
        setTableViewDelegate()
        setNotificationObserver()
    }
    
    // MARK: - UI Methods
    
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
        groupListView.addGroupButton.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Data Methods
    
    private func loadCategories() {
        categories = CoreDataManager.shared.readCategories()
        groupListView.groupTableView.reloadData()
    }
    
    // MARK: - Delegate Methods
    
    private func setTableViewDelegate() {
        groupListView.groupTableView.delegate = self
        groupListView.groupTableView.dataSource = self
        groupListView.groupTableView.register(NormalGroupListTableViewCell.self,
                                              forCellReuseIdentifier: "NormalGroupCell")
        groupListView.groupTableView.register(EditGroupListTableViewCell.self,
                                              forCellReuseIdentifier: "EditGroupCell")
    }
    
    // MARK: - Notification Methods
    
    private func setNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dataUpdated(_:)),
            name: .GroupDataUpdatedNotification,
            object: nil)
    }
    
    @objc func dataUpdated(_ notification: Notification) {
        loadCategories()
    }
    
    // MARK: - Action Methods
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapEditButton() {
        isEditingMode.toggle()
        groupListView.groupTableView.setEditing(isEditingMode, animated: true)
        navigationItem.rightBarButtonItem?.title = isEditingMode ? "완료" : "편집"
    }
    
    @objc private func addCategoryButtonTapped() {
        let addGroupViewController = AddGroupViewController()
        addGroupViewController.modalPresentationStyle = .fullScreen
        present(addGroupViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension GroupListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.isEditing {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditGroupCell",
                                                           for: indexPath) as? EditGroupListTableViewCell else {
                fatalError("셀을 가져오는데 실패하였습니다.")
            }
            
            let category = categories[indexPath.row]
            cell.titleLabel.text = category.title
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NormalGroupCell",
                                                       for: indexPath) as? NormalGroupListTableViewCell else {
            fatalError("셀을 가져오는데 실패하였습니다.")
        }
        
        let category = categories[indexPath.row]
        cell.configureWithCategory(category)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension GroupListViewController: UITableViewDelegate {
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
    
    private func deleteCategory(at indexPath: IndexPath) {
        let categoryToDelete = categories[indexPath.row]
        CoreDataManager.shared.deleteCategory(category: categoryToDelete)
        categories.remove(at: indexPath.row)
        groupListView.groupTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    private func editCategory(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let addGroupViewController = AddGroupViewController()
        addGroupViewController.editModeOn(category: category)
        addGroupViewController.modalPresentationStyle = .fullScreen
        present(addGroupViewController, animated: true)
    }
}
