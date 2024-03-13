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
    
    private lazy var rawTodoList = dataManager.readTodos()
    private lazy var rawGroupList = dataManager.readCategories()
    
    private var todoList: [TodoModel] {
        if selectedGroup == nil {
            return allTodoList
        } else {
            return filteredTodoList
        }
    }
    private var allTodoList: [TodoModel] {
        convertTodoDatas(todos: rawTodoList)
    }
    private var filteredTodoList: [TodoModel] {
        if let groupIndex = selectedGroup {
            let group = rawGroupList[groupIndex]
            return filterTodoDatas(todos: allTodoList, group: group)
        }
        return convertTodoDatas(todos: rawTodoList)
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
    
    @objc func dataUpdated(_ notification: Notification) {
        todoDataFetch()
        todoView.todoTableView.reloadData()
    }
    
    @objc func dataUpdatedGroup(_ notification: Notification) {
        groupDataFetch()
        todoView.groupCollectionView.reloadData()
    }
}

// MARK: - Action

extension TodoListViewController {
    private func setAction() {
        todoView.groupListButton.addTarget(self, action: #selector(categoryListButtonTapped), for: .touchUpInside)
        todoView.allGroupButton.addTarget(self, action: #selector(allGroupButtonTapped), for: .touchUpInside)
    }
    
    @objc private func categoryListButtonTapped() {
        self.navigationController?.pushViewController(GroupListViewController(), animated: true)
    }
    
    @objc private func allGroupButtonTapped(sender: UIButton) {
        selectedGroup = nil
        todoView.allGroupButton.alpha = 1
        todoView.groupCollectionView.reloadData()
        todoView.todoTableView.reloadData()
    }
}

// MARK: - Set Methods

extension TodoListViewController {
    
    private func setDelegates() {
        setCollectionView()
        setTableView()
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
        
        return rawGroupList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCollectionViewCell.identifier,
                                                            for: indexPath) as? GroupCollectionViewCell else
        { return UICollectionViewCell() }
        
        cell.configure(data: rawGroupList[indexPath.row])
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
        guard let buttonText = rawGroupList[indexPath.row].title else { return CGSize() }
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
            withIdentifier: TDTableViewCell.identifier,
            for: indexPath) as? TDTableViewCell else
        { return UITableViewCell() }
        
        let rawTodo = self.convertToRawTodo(self.todoList[indexPath.row])
        
        cell.onCheckButtonTapped = {
            rawTodo.isCompleted = !rawTodo.isCompleted
            self.dataManager.saveContext()
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        cell.checkButton.isSelected = rawTodo.isCompleted
        
        cell.configure(data: todoList[indexPath.row], iconImage: UIImage(named: "AddTodoMapPin")!)
        
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

            let addTodoViewViewController = AddTodoViewController()
            let convertedTodo = self.todoList[indexPath.row]
            
            addTodoViewViewController.todoToEdit = self.convertToRawTodo(convertedTodo)
            addTodoViewViewController.modalPresentationStyle = .fullScreen
            self.present(addTodoViewViewController, animated: true)
        })
        let deleteAction = UIContextualAction(style: .normal,
                                              title: "삭제",
                                              handler: {(action, view, completionHandler) in
            
            let convertTodo = self.todoList[indexPath.row]
            let rawTodo = self.convertToRawTodo(convertTodo)
            
            self.dataManager.deleteTodo(todo: rawTodo)
            self.todoDataFetch()
            
            tableView.reloadData()
        })
        
        editAction.backgroundColor = .systemBlue
        deleteAction.backgroundColor = .systemRed
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return swipeActions
    }
}

// MARK: - Data Convert Method

extension TodoListViewController {
    private func convertTodoDatas(todos: [Todo]) -> [TodoModel] {
        let convertedTodos = todos.map { convertTodoData($0) }

        return convertedTodos
    }
    
    private func convertTodoData(_ todo: Todo) -> TodoModel {
        var convertedCategory: CategoryModel?
        var convertedTodo: TodoModel
        
        if let category = todo.category {
            convertedCategory = CategoryModel(id: category.id,
                                              title: category.title!,
                                              color: category.color,
                                              indexNumber: category.indexNumber,
                                              todo: nil) // 일단 nil로 초기화
        }
        
        convertedTodo = TodoModel(id: todo.id, title: todo.title!,
                                  dueDate: todo.dueDate, dueTime: todo.dueTime,
                                  place: todo.place,
                                  isCompleted: todo.isCompleted, fixed: todo.fixed,
                                  timeAlarm: todo.timeAlarm, placeAlarm: todo.placeAlarm,
                                  category: convertedCategory)

        convertedCategory?.todo = convertedTodo
        return convertedTodo
    }
    
    private func filterTodoDatas(todos: [TodoModel], group: Category) -> [TodoModel] {
        return todos.filter { $0.category?.id == group.id }
    }
    
    private func convertToRawTodo(_ todo: TodoModel) -> Todo {
        return rawTodoList.filter { $0.id == todo.id }[0]
    }
}

// MARK: - Data Fetch Method

extension TodoListViewController {
    private func todoDataFetch() {
        rawTodoList = dataManager.readTodos()
    }
    
    private func groupDataFetch() {
        rawGroupList = dataManager.readCategories()
    }
}
