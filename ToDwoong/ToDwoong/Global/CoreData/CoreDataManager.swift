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
    
    // MARK: - TODO CRUD
    
    func createTodo(todo: Todo) {
        let newTodo = Todo(context: context)
        newTodo.id = UUID()
        newTodo.title = todo.title
        newTodo.isCompleted = todo.isCompleted
        newTodo.dueTime = todo.dueTime
        newTodo.placeName = todo.placeName
        newTodo.group = todo.group
        newTodo.timeAlarm = todo.timeAlarm
        newTodo.placeAlarm = todo.placeAlarm
        
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
        do {
            let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
            let dueTimeSortDescriptor = NSSortDescriptor(key: "dueTime", ascending: true)
            fetchRequest.sortDescriptors = [dueTimeSortDescriptor]
            
            let todos = try context.fetch(fetchRequest)
            let data = todos.compactMap { todo -> TodoDTO? in
                guard let id = todo.id, let title = todo.title else { return nil }
                return TodoDTO(id: id,
                               title: title,
                               isCompleted: todo.isCompleted,
                               dueTime: todo.dueTime,
                               placeName: todo.placeName,
                               group: todo.group)
            }
            return data
        } catch {
            print("투두목록 불러오기 실패")
            return []
        }
    }
    
    
    func updateTodo(info: TodoType) {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", info.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            guard let todoToUpdate = results.first else {
                print("해당 ID를 가진 Todo를 찾을 수 없습니다.")
                return
            }
            
            todoToUpdate.title = info.title
            todoToUpdate.isCompleted = info.isCompleted
            todoToUpdate.dueTime = info.dueTime
            todoToUpdate.placeName = info.placeName
            todoToUpdate.timeAlarm = info.timeAlarm
            
            if let groupInfo = info.group, let existingGroup = findGroupById(groupInfo.id) {
                existingGroup.title = groupInfo.title
                existingGroup.color = groupInfo.color ?? existingGroup.color
                existingGroup.indexNumber = Int32(groupInfo.indexNumber ?? Int32(existingGroup.indexNumber))
                todoToUpdate.group = existingGroup
            } else {
                print("해당 ID를 가진 Group을 찾을 수 없습니다.")
            }
            
            if let placeAlarmInfo = info.placeAlarm, let existingPlaceAlarm = findPlaceAlarmById(placeAlarmInfo.id) {
                existingPlaceAlarm.distance = Int32(placeAlarmInfo.distance)
                existingPlaceAlarm.latitude = placeAlarmInfo.latitude
                existingPlaceAlarm.longitude = placeAlarmInfo.longitude
                todoToUpdate.placeAlarm = existingPlaceAlarm
            } else {
                print("해당 ID를 가진 PlaceAlarm을 찾을 수 없습니다.")
            }
            
            try context.save()
        } catch let error {
            print("투두 업데이트 실패: \(error.localizedDescription)")
        }
    }
    
    func deleteTodo(todo: TodoDTO) {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", todo.id as CVarArg)
        do {
            let results = try context.fetch(fetchRequest)
            
            if let todoToDelete = results.first {
                context.delete(todoToDelete)
                saveContext()
            } else {
                print("삭제할 Todo를 찾을 수 없습니다.")
            }
        } catch let error {
            print("투두 삭제 실패: \(error.localizedDescription)")
        }
        
        saveContext()
    }
    
    // MARK: - Group CRUD
    
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
            print("그룹 불러오기 실패")
            return []
        }
    }
    
    func updateGroup(info: GroupUpdateDTO) {
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", info.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let groupToUpdate = results.first {
                if let newTitle = info.title {
                    groupToUpdate.title = newTitle
                }
                if let newColor = info.color {
                    groupToUpdate.color = newColor
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
    
    // MARK: Filter Todo
    
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
    
    // FIXME: 제네릭 사용하여 공통 메서드 만들 수 있을 듯 - findById
    
    private func findGroupById(_ id: UUID) -> Group? {
        let request: NSFetchRequest<Group> = Group.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try? context.fetch(request).first
    }

    private func findPlaceAlarmById(_ id: UUID) -> PlaceAlarm? {
        let request: NSFetchRequest<PlaceAlarm> = PlaceAlarm.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try? context.fetch(request).first
    }
}
