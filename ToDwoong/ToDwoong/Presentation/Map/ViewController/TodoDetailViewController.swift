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
    
    // Properties
    
    var detailView: TodoDetailView!
    var selectedCategoryTitle: String? {
        didSet {
            loadTodosForSelectedCategory()
        }
    }
    
    // Storage
    
    var todos: [TodoModel] = []
    
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

extension TodoDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TDTableViewCell.identifier,
                                                       for: indexPath) as? TDTableViewCell else {
            return UITableViewCell()
        }
        let todo = todos[indexPath.row]
        cell.configure(data: todo, iconImage: UIImage.addTodoMapPin)
        return cell
    }
}

extension TodoDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
