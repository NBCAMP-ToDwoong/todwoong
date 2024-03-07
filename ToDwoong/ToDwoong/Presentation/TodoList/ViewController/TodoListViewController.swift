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
    let dataManager = CoreDataManager.shared
    
    lazy var rawTodoList = dataManager.readTodos()
    lazy var rawGroupList = dataManager.readCategories()
    
    var convertTodoList: [TodoModel] {
        convertTodoDatas(todos: rawTodoList)
    }
    var filteredTodoList: [TodoModel] {
        if let groupIndex = selectedGroup {
            let group = rawGroupList[groupIndex]
            return filterTodoDatas(todos: convertTodoList, group: group)
        } else {
            return convertTodoList
        }
    }
    
    var selectedGroup: Int?
    
    lazy var buttonAction: ((UIButton) -> Void) = { button in
        self.selectedGroup = button.tag
        self.todoView.allGroupButton.alpha = 0.3
        
        self.todoView.groupCollectionView.reloadData()
        self.todoView.todoTableView.reloadData()
    }
    
    // MARK: - UI Properties
    
    var todoView = TodoListView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = todoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        setAction()
    }
}

// MARK: - Action

extension TodoListViewController {
    func setAction() {
        todoView.groupListButton.addTarget(self, action: #selector(categoryListButtonTapped), for: .touchUpInside)
        todoView.allGroupButton.addTarget(self, action: #selector(allGroupButtonTapped), for: .touchUpInside)
    }
    
    @objc func categoryListButtonTapped() {
        
        // FIXME: 그룹 뷰컨트롤러로 이동 (GroupList 구현 이후 연결 예정)
        
        //        self.navigationController?.pushViewController(GroupListViewController, animated: true)
    }
    
    @objc func allGroupButtonTapped(sender: UIButton) {
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

// MARK: - CollectionViewDelegate

extension TodoListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // FIXME: 그룹 필터 로직 구현 예정
        
    }
}

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
        if filteredTodoList.isEmpty {
            todoView.emptyImageView.isHidden = false
            todoView.emptyLabel.isHidden = false
        } else {
            todoView.emptyImageView.isHidden = true
            todoView.emptyLabel.isHidden = true
        }
        
        return filteredTodoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TDTableViewCell.identifier,
            for: indexPath) as? TDTableViewCell else
        { return UITableViewCell() }
        
        let rawTodo = self.convertToRawTodo(self.filteredTodoList[indexPath.row])
        
        cell.onCheckButtonTapped = {
            rawTodo.isCompleted = !rawTodo.isCompleted
            self.dataManager.saveContext()
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        cell.checkButton.isSelected = rawTodo.isCompleted
        
        cell.configure(data: filteredTodoList[indexPath.row])
        
        return cell
    }
}

// MARK: - TableViewDelegate

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // FIXME: 해당 투두 편집 화면으로 이동(투두 편집 화면 구현 이후 추가 예정)
        
    }
    
    // FIXME: MVP 이후 구현 예정
    
//    func tableView(_ tableView: UITableView,
//                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
//    -> UISwipeActionsConfiguration? {
//        let topFixedAction = UIContextualAction(style: .normal,
//                                                title: "고정",
//                                                handler: {(action, view, completionHandler) in
//
//        })
//        
//        topFixedAction.backgroundColor = .systemGray
//        
//        let swipeActions = UISwipeActionsConfiguration(actions: [topFixedAction])
//        swipeActions.performsFirstActionWithFullSwipe = false
//        
//        return swipeActions
//    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal,
                                            title: "편집",
                                            handler: {(action, view, completionHandler) in
            // FIXME: Todo 추가 구현 이후 연결 예정
        })
        let deleteAction = UIContextualAction(style: .normal,
                                              title: "삭제",
                                              handler: {(action, view, completionHandler) in
            
            let convertTodo = self.filteredTodoList[indexPath.row]
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
        return todos.filter { $0.category?.title == group.title }
    }
    
    private func convertToRawTodo(_ todo: TodoModel) -> Todo {
        return rawTodoList.filter { $0.id == todo.id }[0]
    }
}

// MARK : - Data Fetch Method

extension TodoListViewController {
    private func todoDataFetch() {
        rawTodoList = dataManager.readTodos()
    }
}
