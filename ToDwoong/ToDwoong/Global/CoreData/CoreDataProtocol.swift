//
//  Protocol.swift
//  ToDwoong
//
//  Created by yen on 3/17/24.
//

import Foundation

protocol TodoManaging {
    func createTodo(todo: TodoType)
    func readTodo(id: UUID) -> Todo?
    func readTodos() -> [TodoDTO]
    func updateTodo(info: TodoUpdateInfo)
    func deleteTodo(todo: Todo)
}

protocol GroupManaging {
    func createGroup(title: String, color: String)
    func readGroups() -> [Group]
    func updateGroup(info: GroupUpdateInfo)
    func deleteGroup(group: Group)
}

protocol CoreDataManging: TodoManaging, GroupManaging { }
