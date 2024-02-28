//
//  CoreDataManager.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 2/28/24.
//

import UIKit
import CoreData

class CoreDataManager {
    // 싱글톤
    static var shared = CoreDataManager()
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    var context: NSManagedObjectContext {
        guard let persistentContainer = self.persistentContainer else {
            fatalError("Persistent container is nil")
        }
        return persistentContainer.viewContext
    }
    
    // MARK: fetchRequest
    let todoRequest = Todo.fetchRequest()
    let categoryRequest = Category.fetchRequest()
    
    // MARK: Todo Methods
    // Create
    func createTodo(title: String, place: String?, dueDate: Date?, dueTime: Date, isCompleted: Bool, timeAlarm: Bool, placeAlarm: Bool, category: Category?) {
        let newTodo = Todo(context: context)
        newTodo.id = UUID()
        newTodo.title = title
        newTodo.place = place
        newTodo.dueDate = dueDate
        newTodo.dueTime = dueTime
        newTodo.isCompleted = isCompleted
        newTodo.timeAlarm = timeAlarm
        newTodo.placeAlarm = placeAlarm
        newTodo.category = category
        
        do {
            try context.save()
        } catch {
            context.rollback()
            print("오류가 발생하여 투두 생성에 실패하였습니다. \(error.localizedDescription)")
        }
    }
    
    // Read
    func readTodo() -> [Todo] {
        do {
            let todos = try context.fetch(todoRequest) as [Todo]
            return todos
        } catch {
            print("투두 불러오기 실패")
            return []
        }
    }
    
    // Update
    func updateTodo(todo: Todo, newTitle: String, newPlace: String, newDate: Date?, newTime: Date, newCompleted: Bool, newTimeAlarm: Bool, newPlaceAlarm: Bool, newCategory: Category?) {
        todo.title = newTitle
        todo.place = newPlace
        todo.dueDate = newDate
        todo.dueTime = newTime
        todo.isCompleted = newCompleted
        todo.timeAlarm = newTimeAlarm
        todo.placeAlarm = newPlaceAlarm
        todo.category = newCategory
        do {
            try context.save()
        } catch {
            context.rollback()
            print("오류가 발생하여 투두 업데이트에 실패하였습니다. \(error.localizedDescription)")
        }
    }
    
    // Delete
    func deleteTodo(todo: Todo) {
        context.delete(todo)
        do {
            try context.save()
        } catch {
            context.rollback()
            print("오류가 발생하여 투두 삭제에 실패하였습니다. \(error.localizedDescription)")
        }
    }
    
    // MARK: Category Methods
    // Create
    func createCategory(title: String, color: String, todo: Todo?) {
        let newCategory = Category(context: context)
        newCategory.id = UUID()
        newCategory.title = title
        newCategory.color = color
        newCategory.todo = todo
        
        do {
            try context.save()
        } catch {
            context.rollback()
            print("오류가 발생하여 카테고리 생성에 실패하였습니다. \(error.localizedDescription)")
        }
    }
    
    // Read
    func readCategory() -> [Category] {
        do {
            let categories = try context.fetch(categoryRequest) as [Category]
            return categories
        } catch {
            print("카테고리 불러오기 실패")
            return []
        }
    }
    
    // Update
    func updateCategory(category: Category, newTitle: String, newColor: String, newTodo: Todo?) {
        category.title = newTitle
        category.color = newColor
        category.todo = newTodo
        
        do {
            try context.save()
        } catch {
            context.rollback()
            print("오류가 발생하여 카테고리 업데이트에 실패하였습니다. \(error.localizedDescription)")
        }
    }
    
    // Delete
    func deleteCategory(category: Category) {
        context.delete(category)
        do {
            try context.save()
        } catch {
            context.rollback()
            print("오류가 발생하여 카테고리 삭제에 실패하였습니다. \(error.localizedDescription)")
        }
    }
    
    // MARK: Filter Todo
    // 카테고리별로 투두를 분류할때
    func filterTodoByCategory(category: Category) -> [Todo] {
        do {
            let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "category == %@", category)
            let filteredTodos = try context.fetch(fetchRequest)
            return filteredTodos
        } catch {
            print("투두 필터링 실패: \(error.localizedDescription)")
            return []
        }
    }
}
