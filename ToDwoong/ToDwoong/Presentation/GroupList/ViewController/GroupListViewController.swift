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
    private var groups: [Group] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setGroupListView()
        fetchGroup()
        setTableViewDelegate()
        setNotificationObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        navigationController?.navigationBar.tintColor = TDStyle.color.mainTheme
    }
    
    private func setGroupListView() {
        view.addSubview(groupListView)
        
        groupListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        groupListView.backgroundColor = TDStyle.color.lightGray
        groupListView.addGroupButton.addTarget(self, action: #selector(addGroupButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Data Methods
    
    private func fetchGroup() {
        groups = CoreDataManager.shared.readGroups()
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
        fetchGroup()
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
    
    @objc private func addGroupButtonTapped() {
        let addGroupViewController = AddGroupViewController()
        addGroupViewController.modalPresentationStyle = .fullScreen
        present(addGroupViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension GroupListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.isEditing {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditGroupCell",
                                                           for: indexPath) as? EditGroupListTableViewCell else {
                fatalError("셀을 가져오는데 실패하였습니다.")
            }
            
            let group = groups[indexPath.row]
            cell.titleLabel.text = group.title
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NormalGroupCell",
                                                       for: indexPath) as? NormalGroupListTableViewCell else {
            fatalError("셀을 가져오는데 실패하였습니다.")
        }
        
        let group = groups[indexPath.row]
        cell.configureWithGroup(group)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension GroupListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completion) in
            
            AlertController.presentDeleteAlert(on: self,
                                               message: "이 그룹과 그룹에 속한 모든 할 일 목록이 영구적으로 삭제됩니다!",
                                               cancelHandler: {
                completion(false)
            },
                                               confirmHandler: {
                self.deleteGroup(at: indexPath)
                NotificationCenter.default.post(name: .GroupDataUpdatedNotification, object: nil)
                NotificationCenter.default.post(name: .TodoDataUpdatedNotification, object: nil)
                completion(true)
            })
        }
        
        let editAction = UIContextualAction(style: .normal, title: "편집") { (action, view, completion) in
            self.editGroup(at: indexPath)
            completion(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        editAction.backgroundColor = .systemBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        let movedGroup = groups.remove(at: sourceIndexPath.row)
        groups.insert(movedGroup, at: destinationIndexPath.row)
        
        for (index, group) in groups.enumerated() {
            group.indexNumber = Int32(index)
        }
        
        let context = CoreDataManager.shared.context
        do {
            try context.save()
        } catch {
            print("Core Data 컨텍스트 저장 실패: \(error)")
        }
    }
    
    private func deleteGroup(at indexPath: IndexPath) {
        let groupToDelete = groups[indexPath.row]
        CoreDataManager.shared.deleteGroup(group: groupToDelete)
        fetchGroup()
        groupListView.groupTableView.reloadData()
    }
    
    private func editGroup(at indexPath: IndexPath) {
        let group = groups[indexPath.row]
        let addGroupViewController = AddGroupViewController()
        addGroupViewController.editModeOn(group: group)
        addGroupViewController.modalPresentationStyle = .fullScreen
        present(addGroupViewController, animated: true)
    }
}
