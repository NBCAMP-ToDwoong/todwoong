//
//  ViewController.swift
//  ToDwoong
//
//  Created by yen on 2/23/24.
//

import UIKit

import TodwoongDesign

class TodoViewController: UIViewController {
    
    // MARK: - Properties
    let dataManager = CoreDataManager.shared
    var rawTodoList: [Todo] {
        dataManager.readTodos()
    }
    var convertTodoList: [TodoModel] {
        convertTodoDatas(todos: rawTodoList)
    }
    lazy var groupList = dataManager.readCategories()
    
    // MARK: - UI Properties
    
    var todoView = TodoView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = todoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.createTodo(title: "Test", place: "서울특별시 강남구", dueDate: nil, dueTime: nil, isCompleted: false, timeAlarm: false, placeAlarm: false, category: nil)
        
        setDelegates()
        setAction()
    }
}

// MARK: - Action

extension TodoViewController {
    func setAction() {
        todoView.groupListButton.addTarget(self, action: #selector(categoryListButtonTapped), for: .touchUpInside)
    }
    
    @objc func categoryListButtonTapped() {
        
        // FIXME: 그룹 뷰컨트롤러로 이동 (GroupList 구현 이후 연결 예정)
        
        //        self.navigationController?.pushViewController(GroupListViewController, animated: true)
    }
}

// MARK: - Set Methods

extension TodoViewController {
    
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

extension TodoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return groupList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCollectionViewCell.identifier,
                                                            for: indexPath) as? GroupCollectionViewCell else
        { return UICollectionViewCell() }
        
        cell.configure(data: groupList[indexPath.row])
        
        return cell
    }
}

// MARK: - CollectionViewDelegate

extension TodoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // FIXME: 그룹 필터 로직 구현 예정
        
    }
}

extension TodoViewController: UICollectionViewDelegateFlowLayout {
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

extension TodoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if convertTodoList.isEmpty {
            todoView.emptyImageView.isHidden = false
            todoView.emptyLabel.isHidden = false
        } else {
            todoView.emptyImageView.isHidden = true
            todoView.emptyLabel.isHidden = true
        }
        
        return convertTodoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TDTableViewCell.identifier,
            for: indexPath) as? TDTableViewCell else
        { return UITableViewCell() }
        
        cell.onCheckButtonTapped = {
            cell.checkButton.isSelected = !cell.checkButton.isSelected
        }
        cell.configure(data: convertTodoList[indexPath.row])
        
        return cell
    }
}

// MARK: - TableViewDelegate

extension TodoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // FIXME: 해당 투두 편집 화면으로 이동(투두 편집 화면 구현 이후 추가 예정)
        
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let topFixedAction = UIContextualAction(style: .normal,
                                                title: "고정",
                                                handler: {(action, view, completionHandler) in
            // FIXME: 기능 Feature에서 구현 예정
        })
        
        topFixedAction.backgroundColor = .systemGray
        
        let swipeActions = UISwipeActionsConfiguration(actions: [topFixedAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal,
                                            title: "편집",
                                            handler: {(action, view, completionHandler) in
            // FIXME: 기능 Feature에서 구현 예정
        })
        let deleteAction = UIContextualAction(style: .normal,
                                              title: "삭제",
                                              handler: {(action, view, completionHandler) in
            self.dataManager.deleteTodo(todo: self.rawTodoList[indexPath.row])
            tableView.reloadData()
        })
        
        editAction.backgroundColor = .systemBlue
        deleteAction.backgroundColor = .systemRed
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return swipeActions
    }
}

// MARK: - Data Convert Method

extension TodoViewController {
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
}
