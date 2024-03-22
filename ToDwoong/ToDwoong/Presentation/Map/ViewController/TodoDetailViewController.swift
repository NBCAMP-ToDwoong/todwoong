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
    
    var detailView: TodoDetailView!
    var selectedCategoryTitle: String?
    var selectedCategoryIndex: Int? 
    
    // MARK: - Data Storage
    
    var todos: [TodoModel] = []
    
    // MARK: - Lifecycle
    
    override func loadView() {
        detailView = TodoDetailView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailView.tableView.dataSource = self
        detailView.tableView.delegate = self
        
        loadTodosForSelectedCategory()
    }
    
    // MARK: - Setting Method
    
    func loadTodosForSelectedCategory() {
//        if let index = selectedCategoryIndex {
//            if index == -1 {
//                todos = CoreDataManager.shared.readTodos().map { $0.toTodoModel() }
//            } else {
//                todos = CoreDataManager.shared.readTodos().filter
//                { $0.category?.indexNumber == Int32(index) }.map
//                { $0.toTodoModel() }
//            }
//        } else {
//            todos = CoreDataManager.shared.readTodos().map { $0.toTodoModel() }
//        }
            
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

// MARK: - UITableViewDataSource

extension TodoDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TDTableViewCell.identifier,
                                                       for: indexPath) as? TDTableViewCell
        else {
            return UITableViewCell()
        }
        
        let todo = todos[indexPath.row]
        cell.configure(data: todo, iconImage: UIImage.addTodoMapPin)
        cell.checkButton.isSelected = todo.isCompleted
        
        cell.onCheckButtonTapped = { [weak self] in
            guard let self = self else { return }
            
            let todo = self.todos[indexPath.row]
            todo.isCompleted.toggle()
            let todoEntity = CoreDataManager.shared.readTodos().first { $0.id == todo.id }
//            todoEntity?.isCompleted = todo.isCompleted
            CoreDataManager.shared.saveContext()
            NotificationCenter.default.post(name: .TodoDataUpdatedNotification, object: nil)
            
            cell.checkButton.isSelected = todo.isCompleted
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TodoDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodo = todos[indexPath.row]
        
        if let mapViewController = presentingViewController as? MapViewController {
            mapViewController.zoomToTodo(selectedTodo) {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
