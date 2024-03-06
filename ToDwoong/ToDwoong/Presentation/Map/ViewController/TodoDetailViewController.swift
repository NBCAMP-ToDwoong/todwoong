//
//  TodoDetailViewController.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 3/6/24.
//

import UIKit
import TodwoongDesign

class TodoDetailViewController: UIViewController {
    
    // MARK: - Storage
    
    var todos: [TodoModel] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTodos() // 실제 데이터 로딩
    }
    
    func loadTodos() {
        // 실제 Todo 데이터를 로드하는 로직 구현
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
        cell.configure(data: todo)
        return cell
    }
}


