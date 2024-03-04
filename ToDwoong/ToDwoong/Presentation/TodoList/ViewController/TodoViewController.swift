//
//  ViewController.swift
//  ToDwoong
//
//  Created by yen on 2/23/24.
//

import UIKit

import TodwoongDesign

class TodoViewController: UIViewController {
    
    // MARK: Properties
    
    lazy var todoList = convertTodoDatas(todos: CoreDataManager.shared.readTodos())
    var groupList = CoreDataManager.shared.readCategories()
    
    // MARK: UI Properties
    
    var todoView = TodoView()
    
    // MARK: Life Cycle
    
    override func loadView() {
        view = todoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        setAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
}

// MARK: Action

extension TodoViewController {
    func setAction() {
        todoView.groupListButton.addTarget(self, action: #selector(categoryListButtonTapped), for: .touchUpInside)
    }
    
    @objc func categoryListButtonTapped() {
        
        // FIXME: 그룹 뷰컨트롤러로 이동 (GroupList 구현 이후 연결 예정)
        
        //        self.navigationController?.pushViewController(GroupListViewController, animated: true)
    }
}

// MARK: Set Methods

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

// MARK: CollectionView DataSource

extension TodoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // FIXME: 그룹 리스트 매핑 예정
        
        //        return groupList.count
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCollectionViewCell.identifier, for: indexPath) as? GroupCollectionViewCell else {
            
            //FIXME: 그룹 데이터 매핑 예정
            
            //            cell.configure(data: <#T##Category#>)
            
            return UICollectionViewCell()
        }
        return cell
    }
}

// MARK: CollectionViewDelegate

extension TodoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // FIXME: 그룹 필터 로직 구현 예정
        
    }
}

extension TodoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buttonText = "Test"
        let buttonSize = buttonText.size(withAttributes: [NSAttributedString.Key.font : TDStyle.font.body(style: .regular)])
        let buttonWidth = buttonSize.width
        let buttonHeight = buttonSize.height
        
        return CGSize(width: buttonWidth + 24, height: buttonHeight + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

// MARK: TableView DataSource

extension TodoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // FIXME: 투두 리스트 매핑 예정
        //        return todoList.count
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TDTableViewCell.identifier, for: indexPath) as? TDTableViewCell else { return UITableViewCell() }
        
        // FIXME: 데이터 매핑 예정
        cell.onCheckButtonTapped = {
            cell.checkButton.isSelected = !cell.checkButton.isSelected
        }
        //            cell.configure(data: test)
        
        return cell
    }
}

// MARK: TableView Delegate

extension TodoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // FIXME: 해당 투두 편집 화면으로 이동 추가 예정
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let topFixedAction = UIContextualAction(style: .normal, title: "고정", handler: {(action, view, completionHandler) in
            
        })
        
        topFixedAction.backgroundColor = .systemGray
        
        let swipeActions = UISwipeActionsConfiguration(actions: [topFixedAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "편집", handler: {(action, view, completionHandler) in
            
        })
        let deleteAction = UIContextualAction(style: .normal, title: "삭제", handler: {(action, view, completionHandler) in
            
        })
        
        editAction.backgroundColor = .systemBlue
        deleteAction.backgroundColor = .systemRed
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return swipeActions
    }
}

// MARK: Data Convert Method

extension TodoViewController {
    private func convertTodoDatas(todos: [Todo]) -> [TodoModel] {
        let convertedTodos = todos.map { convertTodoData($0) }
        
        return convertedTodos
    }
    
    private func convertTodoData(_ todo: Todo) -> TodoModel {
        
        if let id = todo.id?.uuidString {
            if let title = todo.title {
                var convertedTodo = TodoModel(id: id, title: title, isCompleted: todo.isCompleted, placeAlarm: todo.placeAlarm, timeAlarm: todo.timeAlarm)
                convertedTodo.dueDate = todo.dueDate
                convertedTodo.dueTime = todo.dueTime
                convertedTodo.place = todo.place
                convertedTodo.category = todo.category?.title
                
                return convertedTodo
            }
        }
        return TodoModel(id: "error", title: "error", isCompleted: false, placeAlarm: false, timeAlarm: false)
    }
}
