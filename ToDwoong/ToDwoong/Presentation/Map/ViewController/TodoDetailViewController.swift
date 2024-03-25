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
    
    // MARK: - Data Storage
    
    var todoList: [TodoType] = [] {
        didSet {
            DispatchQueue.main.async {
                self.detailView.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Initializer
    
    init(todos: [TodoType]) {
        self.todoList = todos
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
        var filteredTodos: [TodoType] = []
        
        if let selectedTitle = self.selectedCategoryTitle {
            filteredTodos = self.todoList.filter { $0.group?.title == selectedTitle }
        } else {
            filteredTodos = self.todoList
        }

        self.todoList = filteredTodos
        
        if self.todoList.isEmpty {
            detailView.emptyImageView.isHidden = false
            detailView.emptyLabel.isHidden = false
        } else {
            detailView.emptyImageView.isHidden = true
            detailView.emptyLabel.isHidden = true
        }
        
        DispatchQueue.main.async {
            self.detailView.tableView.reloadData()
        }
    }
}

extension TodoDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoListTableViewCell.identifier,
            for: indexPath) as? TodoListTableViewCell else
        { return UITableViewCell() }
        
        let todo = todoList[indexPath.row]
        
        let configureData = dataManager.readTodoToDTO(id: todo.id)
        cell.configure(todo: configureData!)
        
        cell.tdCellView.onCheckButtonTapped = {
            todo.isCompleted = !todo.isCompleted
            self.dataManager.updateIsCompleted(id: todo.id, status: todo.isCompleted)
            NotificationCenter.default.post(name: .TodoDataUpdatedNotification, object: nil)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        return cell
    }
}

extension TodoDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = dataManager.readTodo(id: todoList[indexPath.row].id)
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
            
        // FIXME: 투두추가 화면 구현 이후 수정
        //            let addTodoViewViewController = AddTodoViewController()
        //            let todo = self.todoList[indexPath.row]
        //
        //            self.present(addTodoViewViewController, animated: true)
        })

        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completionHandler) in
            if indexPath.row < self.todoList.count {
                self.dataManager.deleteTodoByID(id: self.todoList[indexPath.row].id)
                
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
