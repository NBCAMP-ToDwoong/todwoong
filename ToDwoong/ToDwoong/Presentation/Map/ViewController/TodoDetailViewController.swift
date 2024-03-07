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
    
    var detailView: TodoDetailView!
    var todos: [TodoModel] = []
    
    override func loadView() {
        detailView = TodoDetailView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.tableView.dataSource = self
        detailView.tableView.delegate = self
        loadMockData()
    }
    
    func loadMockData() {
        let workCategory = CategoryModel(id: UUID(), title: "일", color: "bgBlue", indexNumber: 0, todo: nil)
        let personalCategory = CategoryModel(id: UUID(), title: "집", color: "bgRed", indexNumber: 1, todo: nil)

        todos = [
            TodoModel(id: UUID(), title: "프로젝트 끝내기",
                      dueDate: Date(),
                      dueTime: Date(),
                      place: "부산",
                      isCompleted: false,
                      fixed: false,
                      timeAlarm: true,
                      placeAlarm: true,
                      category: workCategory),
            TodoModel(id: UUID(),
                      title: "체육관",
                      dueDate: Date().addingTimeInterval(86400),
                      dueTime: Date(),
                      place: "대구",
                      isCompleted: false,
                      fixed: false,
                      timeAlarm: true,
                      placeAlarm: true,
                      category: personalCategory),
            TodoModel(id: UUID(),
                      title: "으아",
                      dueDate: Date().addingTimeInterval(2 * 86400),
                      dueTime: Date(),
                      place: "서울",
                      isCompleted: false,
                      fixed: false,
                      timeAlarm: true,
                      placeAlarm: true,
                      category: personalCategory)
        ]

            detailView.tableView.reloadData()
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
