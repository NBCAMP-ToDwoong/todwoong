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
    var todoList: [TodoType] = [] {
        didSet { reloadDetailViewTable() }
    }
    
    // MARK: - UI Properties
    
    private lazy var dataManager = CoreDataManager.shared
    private var detailView: TodoDetailView!
    
    // MARK: - Lifecycle
    
    init(todos: [TodoType]) {
        self.todoList = todos
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        detailView = TodoDetailView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        loadTodosForSelectedGroup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setting Method

extension TodoDetailViewController {
    private func setTableView() {
        detailView.tableView.register(TodoListTableViewCell.self,
                                      forCellReuseIdentifier: TodoListTableViewCell.identifier)
        detailView.tableView.dataSource = self
        detailView.tableView.delegate = self
    }
    
    func loadTodosForSelectedGroup() {
        if self.todoList.isEmpty {
            detailView.emptyImageView.isHidden = false
            detailView.emptyLabel.isHidden = false
        } else {
            detailView.emptyImageView.isHidden = true
            detailView.emptyLabel.isHidden = true
        }
        reloadDetailViewTable()
    }
    
    func reloadDetailViewTable() {
        DispatchQueue.main.async {
            self.detailView.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

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
        
        guard let configureData = dataManager.readTodoToDTO(id: todo.id) else { return cell }
        cell.configure(todo: configureData)
        
        cell.tdCellView.onCheckButtonTapped = {
            todo.isCompleted = !todo.isCompleted
            self.dataManager.updateIsCompleted(id: todo.id, status: todo.isCompleted)
            NotificationCenter.default.post(name: .TodoDataUpdatedNotification, object: nil)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

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
            
            let addTodoViewViewController = AddTodoViewController()
            let todo = self.dataManager.readTodoToDTO(id: self.todoList[indexPath.row].id)
            addTodoViewViewController.todoToEdit = todo
            
            self.present(addTodoViewViewController, animated: true)
        })
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completion) in
            
            AlertController.presentDeleteAlert(on: self,
                                               message: "이 투두가 영구히 삭제됩니다!",
                                               cancelHandler: { completion(false) },
                                               confirmHandler: {
                if indexPath.row < self.todoList.count {
                    self.dataManager.deleteTodoByID(id: self.todoList[indexPath.row].id)
                    
                    NotificationCenter.default.post(name: .TodoDataUpdatedNotification, object: nil)
                    self.detailView.tableView.reloadData()
                    NotificationCenter.default.post(name: .todoDeleted, object: nil)
                }
            })
        }
        
        editAction.backgroundColor = .systemBlue
        deleteAction.backgroundColor = .systemRed
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return swipeActions
    }
}
