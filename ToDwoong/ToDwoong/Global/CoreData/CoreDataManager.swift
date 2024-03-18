//
//  CoreDataManager2.swift
//  ToDwoong
//
//  Created by yen on 3/17/24.
//

import CoreData
import Foundation

final class CoreDataManager: CoreDataManging {
    
    static var shared: CoreDataManager = CoreDataManager()
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("해결되지 않음 \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            context.rollback()
            print("오류가 발생하였습니다. \(error.localizedDescription)")
        }
    }
    
    // MARK: - Todo
    
    func createTodo(todo: TodoType) {
        let data = Todo(context: context)
        
        data.id = UUID()
        data.title = todo.title
        data.isCompleted = todo.isCompleted
        data.dueTime = todo.dueTime
        data.timeAlarm = todo.timeAlarm
        data.placeName = todo.placeName
        
        saveContext()
    }
    
    func readTodo(id: UUID) -> Todo? {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let todos = try context.fetch(fetchRequest)
            return todos.first
        } catch {
            print("Id로 투두를 가져오는 중 오류 발생 \(id): \(error)")
            return nil
        }
    }
    
    func readTodos() -> [TodoDTO] {
        let allTodos = readAllTodo()
        
        let todoDTO = allTodos.map { todo in
            TodoDTO(id: todo.id!,
                    title: todo.title ?? "",
                    isCompleted: todo.isCompleted,
                    dueTime: todo.dueTime,
                    placeName: todo.placeName,
                    group: todo.group)
        }
        
        print(todoDTO)
        
        return todoDTO
    }
    
    func updateTodo(info: TodoUpdateInfo) {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", info.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let todoToUpdate = results.first {
                
                if let newTitle = info.newTitle {
                    todoToUpdate.title = newTitle
                }
                if let newIsCompleted = info.newIsCompleted {
                    todoToUpdate.isCompleted = newIsCompleted
                }
                if let newDueTime = info.newDueTime {
                    todoToUpdate.dueTime = newDueTime
                }
                if let newTimeAlarm = info.newTimeAlarm {
                    todoToUpdate.timeAlarm = newTimeAlarm
                }
                if let newPlaceName = info.newPlaceName {
                    todoToUpdate.placeName = newPlaceName
                }
                if let newGroup = info.newGroup {
                    todoToUpdate.group = newGroup
                }
                if let newPlaceAlarm = info.newPlaceAlarm {
                    todoToUpdate.placeAlarm = newPlaceAlarm
                }
                
                try context.save()
            }
        } catch let error {
            print("투두 업데이트 실패: \(error.localizedDescription)")
        }
    }
    
    func deleteTodo(todo: Todo) {
        context.delete(todo)
        
        saveContext()
    }
    
    private func readAllTodo() -> [Todo] {
        do {
            let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
            let dueTimeSortDescriptor = NSSortDescriptor(key: "dueTime", ascending: true)
            fetchRequest.sortDescriptors = [dueTimeSortDescriptor]
            let todos = try context.fetch(fetchRequest)
            
            return todos
        } catch {
            print("투두 목록 불러오기 실패")
            return []
        }
    }
    
    // MARK: - Group
    
    func createGroup(title: String, color: String) {
        let newGroup = Group(context: context)
        newGroup.id = UUID()
        newGroup.title = title
        newGroup.color = color
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Group")
        fetchRequest.resultType = .dictionaryResultType
        let calculateDesc = NSExpressionDescription()
        calculateDesc.name = "maxIndexNumber"
        calculateDesc.expression = NSExpression(forFunction: "max:",
                                                arguments: [NSExpression(forKeyPath: "indexNumber")])
        calculateDesc.expressionResultType = .integer64AttributeType
        fetchRequest.propertiesToFetch = [calculateDesc]
        
        do {
            let results = try context.fetch(fetchRequest)
            if let maxIndexNumberDict = results.first as? [String: Int64],
               let maxIndexNumber = maxIndexNumberDict["maxIndexNumber"] {
                newGroup.indexNumber = Int32(maxIndexNumber + 1)
            } else {
                newGroup.indexNumber = 0
            }
        } catch let error as NSError {
            print("Could not fetch maxIndexNumber: \(error), \(error.userInfo)")
            newGroup.indexNumber = 0
        }
        
        saveContext()
    }
    
    func readGroups() -> [Group] {
        do {
            let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "indexNumber", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            let groups = try context.fetch(fetchRequest)
            return groups
        } catch {
            print("groups 불러오기 실패")
            return []
        }
    }
    
    func updateGroup(info: GroupUpdateInfo) {
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", info.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let groupToUpdate = results.first {
                
                if let newTitle = info.newTitle {
                    groupToUpdate.title = newTitle
                }
                if let newColor = info.newColor {
                    groupToUpdate.color = newColor
                }
                if let newIndexNumber = info.newIndexNumber {
                    groupToUpdate.indexNumber = newIndexNumber
                }
                
                try context.save()
            }
        } catch let error {
            print("그룹 업데이트 실패: \(error.localizedDescription)")
        }
    }
    
    func deleteGroup(group: Group) {
        context.delete(group)
        
        saveContext()
    }
    
    // MARK: - AllDelete Method
    
    func deleteAllEntity(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch let error as NSError {
            print("\(entityName) 전체 삭제 오류: \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Filter Method
    
    func filterTodoByGroup(group: Group) -> [Todo] {
        do {
            let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "group == %@", group)
            let filteredTodos = try context.fetch(fetchRequest)
            return filteredTodos
        } catch {
            print("투두 필터링 실패: \(error.localizedDescription)")
            return []
        }
    }
    
    func filterTodoByDuedate(_ date: Date) -> [Todo] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        let dueDatePredicate = NSPredicate(format: "(dueDate >= %@) AND (dueDate < %@)",
                                           startOfDay as NSDate,
                                           endOfDay as NSDate)
        fetchRequest.predicate = dueDatePredicate

        let sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let todos = try context.fetch(fetchRequest)
            return todos
        } catch {
            print("Error fetching todos for date: \(error)")
            return []
        }
    }
}
