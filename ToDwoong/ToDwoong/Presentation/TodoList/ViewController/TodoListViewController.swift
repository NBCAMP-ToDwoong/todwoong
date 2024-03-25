//
//  ViewController.swift
//  ToDwoong
//
//  Created by yen on 2/23/24.
//

import UIKit

import TodwoongDesign

class TodoListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let dataManager = CoreDataManager.shared
    
    private lazy var allTodoList = dataManager.readTodos()
    private lazy var groupList = dataManager.readGroups()
    
    private var todoList: [TodoDTO] {
        if let groupIndex = selectedGroup {
            return allTodoList.filter { $0.group == groupList[groupIndex] }
        } else {
            return allTodoList
        }
    }
    
    private var selectedGroup: Int?
    
    lazy var buttonAction: ((UIButton) -> Void) = { button in
        self.selectedGroup = button.tag
        self.todoView.allGroupButton.alpha = 0.3
        
        self.todoView.groupCollectionView.reloadData()
        self.todoView.todoTableView.reloadData()
    }
    
    // MARK: - UI Properties
    
    private var todoView = TodoListView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = todoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        setAction()
        setNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Action

extension TodoListViewController {
    
    @objc private func groupListButtonTapped() {
        self.navigationController?.pushViewController(GroupListViewController(), animated: true)
    }
    
    @objc private func allGroupButtonTapped(sender: UIButton) {
        selectedGroup = nil
        todoView.allGroupButton.alpha = 1
        todoView.groupCollectionView.reloadData()
        todoView.todoTableView.reloadData()
    }
    
    @objc private func dataUpdated(_ notification: Notification) {
        todoDataFetch()
        todoView.todoTableView.reloadData()
    }
    
    @objc private func dataUpdatedGroup(_ notification: Notification) {
        groupDataFetch()
        todoView.groupCollectionView.reloadData()
    }
}

// MARK: - Set Methods

extension TodoListViewController {
    private func setAction() {
        todoView.groupListButton.addTarget(self, action: #selector(groupListButtonTapped), for: .touchUpInside)
        todoView.allGroupButton.addTarget(self, action: #selector(allGroupButtonTapped), for: .touchUpInside)
    }
    
    private func setDelegates() {
        setCollectionView()
        setTableView()
    }
    
    private func setNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dataUpdated(_:)),
            name: .TodoDataUpdatedNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dataUpdatedGroup(_:)),
            name: .GroupDataUpdatedNotification,
            object: nil)
    }
    
    private func setCollectionView() {
        todoView.groupCollectionView.dataSource = self
        todoView.groupCollectionView.delegate = self
    }
    
    private func setTableView() {
        todoView.todoTableView.dataSource = self
        todoView.todoTableView.delegate = self
    }
}

// MARK: - CollectionViewDataSource

extension TodoListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return groupList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCollectionViewCell.identifier,
                                                            for: indexPath) as? GroupCollectionViewCell else
        { return UICollectionViewCell() }
        
        cell.configure(data: groupList[indexPath.row])
        cell.groupButton.tag = indexPath.row
        cell.buttonAction = buttonAction
        
        if selectedGroup != cell.groupButton.tag {
            cell.groupButton.alpha = 0.3
        } else {
            cell.groupButton.alpha = 1
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TodoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let buttonText = groupList[indexPath.row].title else { return CGSize() }
        let buttonSize = buttonText.size(withAttributes:
                                            [NSAttributedString.Key.font : TDStyle.font.body(style: .regular)])
        let buttonWidth = buttonSize.width
        let buttonHeight = buttonSize.height
        
        return CGSize(width: buttonWidth + 24, height: buttonHeight + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

// MARK: - TableViewDataSource

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todoList.isEmpty {
            todoView.emptyImageView.isHidden = false
            todoView.emptyLabel.isHidden = false
        } else {
            todoView.emptyImageView.isHidden = true
            todoView.emptyLabel.isHidden = true
        }
        
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoListTableViewCell.identifier,
            for: indexPath) as? TodoListTableViewCell else
        { return UITableViewCell() }
        
        var todo = todoList[indexPath.row]
        
        cell.tdCellView.onCheckButtonTapped = {
            todo.isCompleted = !todo.isCompleted
            self.dataManager.updateIsCompleted(id: todo.id, status: todo.isCompleted)
            self.todoDataFetch()
            NotificationCenter.default.post(name: .TodoDataUpdatedNotification, object: nil)
            tableView.reloadRows(at: [indexPath], with: .none)
        }

        cell.tdCellView.onLocationButtonTapped = { [weak self] in
            guard let self = self else { return }
            let mapViewController = MapViewController()
            
            // FIXME: mapViewController 수정 이후 FIX
            
//            self.navigationController?.pushViewController(mapViewController, animated: true)
          }
          
        cell.configure(todo: todo)
        
        return cell
    }
}

// MARK: - TableViewDelegate

extension TodoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal,
                                            title: "편집",
                                            handler: {(action, view, completionHandler) in

            //FIXME: 투두추가 화면 구현 이후 수정
//            let addTodoViewViewController = AddTodoViewController()
//            let todo = self.todoList[indexPath.row]
//            
//            self.present(addTodoViewViewController, animated: true)
        })
        let deleteAction = UIContextualAction(style: .normal,
                                              title: "삭제",
                                              handler: {(action, view, completionHandler) in
            
            self.dataManager.deleteTodo(todo: self.todoList[indexPath.row])
            self.todoDataFetch()
            
            NotificationCenter.default.post(name: .TodoDataUpdatedNotification, object: nil)
            tableView.reloadData()
        })
        
        editAction.backgroundColor = .systemBlue
        deleteAction.backgroundColor = .systemRed
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return swipeActions
    }
}

// MARK: - Data Fetch Method

extension TodoListViewController {
    private func todoDataFetch() {
        allTodoList = dataManager.readTodos()
    }
    
    private func groupDataFetch() {
        groupList = dataManager.readGroups()
    }
}
