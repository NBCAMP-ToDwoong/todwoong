//
//  TodoDetailViewController.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 3/6/24.
//

import UIKit

import SnapKit
import TodwoongDesign

class TodoDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: TodoDetailViewControllerDelegate?
    
    private let dataManager = CoreDataManager.shared
    var detailView: TodoDetailView!
    var selectedCategoryTitle: String?
    var selectedCategoryIndex: Int?
    
    // MARK: - Data Storage
    
    var todos: [TodoDTO]
    
    // MARK: - Initializer
    
    init(todos: [TodoDTO]) {
        self.todos = todos
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        detailView = TodoDetailView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailView.tableView.register(TodoListTableViewCell.self,
                                      forCellReuseIdentifier: TodoListTableViewCell.identifier)
        detailView.tableView.dataSource = self
        detailView.tableView.delegate = self
        
        loadTodosForSelectedCategory()
    }
    
    // MARK: - Setting Method
    
    func loadTodosForSelectedCategory() {
        if let index = selectedCategoryIndex {
            if index == -1 {
                todos = CoreDataManager.shared.readTodos().map { $0 }
            } else {
                todos = CoreDataManager.shared.readTodos().filter
                { $0.group?.indexNumber == Int32(index) }.map
                { $0 }
            }
        } else {
            todos = CoreDataManager.shared.readTodos().map { $0 }
        }
        
        if todos.isEmpty {
            detailView.emptyImageView.isHidden = false
            detailView.emptyLabel.isHidden = false
        } else {
            detailView.emptyImageView.isHidden = true
            detailView.emptyLabel.isHidden = true
        }
        
        detailView.tableView.reloadData()
    }
}

extension TodoDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoListTableViewCell.identifier,
            for: indexPath) as? TodoListTableViewCell else
        { return UITableViewCell() }
        
        var todo = todos[indexPath.row]
        cell.configure(todo: todo)
        
        cell.tdCellView.onCheckButtonTapped = {
            todo.isCompleted = !todo.isCompleted
            self.dataManager.updateIsCompleted(id: todo.id, status: todo.isCompleted)
            self.todoDataFetch()
            NotificationCenter.default.post(name: .TodoDataUpdatedNotification, object: nil)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        return cell
    }
    private func todoDataFetch() {
        todos = dataManager.readTodos()
    }
    
}

extension TodoDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = dataManager.readTodo(id: todos[indexPath.row].id)
        if let placeAlarm = todo?.placeAlarm {
            delegate?.didSelectLocation(latitude: placeAlarm.latitude, longitude: placeAlarm.longitude)
        }
    }
    
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

        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completionHandler) in
            if indexPath.row < self.todos.count {
                self.dataManager.deleteTodo(todo: self.todos[indexPath.row])
                self.todoDataFetch()
                
                NotificationCenter.default.post(name: .TodoDataUpdatedNotification, object: nil)
                tableView.reloadData()
            }
        }
        
        editAction.backgroundColor = .systemBlue
        deleteAction.backgroundColor = .systemRed
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return swipeActions
    }
}
