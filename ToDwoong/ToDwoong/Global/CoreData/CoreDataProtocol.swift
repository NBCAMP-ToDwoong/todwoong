//
//  Protocol.swift
//  ToDwoong
//
//  Created by yen on 3/17/24.
//

import Foundation

protocol TodoManaging {
    func createTodo(todo: Todo)
    func readTodo(id: UUID) -> TodoType?
    func readTodos() -> [TodoDTO]
    func updateTodo(info: TodoType)
    func deleteTodo(todo: TodoDTO)
}

protocol GroupManaging {
    func createGroup(title: String, color: String)
    func readGroups() -> [Group]
    func updateGroup(info: GroupUpdateDTO)
    func deleteGroup(group: Group)
}

protocol CoreDataManging: TodoManaging, GroupManaging { }
