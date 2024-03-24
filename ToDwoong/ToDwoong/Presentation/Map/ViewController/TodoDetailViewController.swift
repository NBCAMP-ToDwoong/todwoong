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
    
    private let dataManager = CoreDataManager.shared
    var detailView: TodoDetailView!
    var selectedCategoryTitle: String?
    var selectedCategoryIndex: Int? 
    
    // MARK: - Data Storage
    
    var todos: [TodoDTO] = []
    
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

extension TodoDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoListTableViewCell.identifier,
            for: indexPath) as? TodoListTableViewCell else
        { return UITableViewCell() }
        
        let todo = todos[indexPath.row]
        cell.configure(todo: todo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection if needed
    }
}
