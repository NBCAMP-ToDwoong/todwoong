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
    var selectedCategoryTitle: String? {
        didSet {
            loadTodosForSelectedCategory()
        }
    }
    
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
        guard let category = selectedCategoryTitle else {
            detailView?.tableView.reloadData()
            return
        }
        
        if category == "전체" {
            detailView?.tableView.reloadData()
        } else {
            todos = todos.filter { $0.category?.title == category }
            detailView?.tableView.reloadData()
        }
    }

}

// MARK: - UITableViewDataSource

extension TodoDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TDTableViewCell.identifier, for: indexPath) as? TDTableViewCell else {
            return UITableViewCell()
        }
        
        let todo = todos[indexPath.row]
        cell.configure(data: todo, iconImage: UIImage.addTodoMapPin)
        cell.checkButton.isSelected = todo.isCompleted
        
        cell.onCheckButtonTapped = { [weak self] in
            guard let self = self else { return }
            
            self.todos[indexPath.row].isCompleted.toggle()
            cell.checkButton.isSelected = self.todos[indexPath.row].isCompleted
        }
        
        cell.onLocationButtonTapped = { [weak self] in
            guard let self = self else { return }
            
            if let mapViewController = self.presentingViewController as? MapViewController {
                mapViewController.zoomToTodo(todo) {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TodoDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
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
