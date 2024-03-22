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
        let container = NSPersistentContainer(name: "ToDwoongModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
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
    
    func createTodo(
        title: String, dueTime: Date?,
        placeName: String?, group: Group?,
        timeAlarm: [Int]?, placeAlarm: PlaceAlarm?
    ) {
        let newTodo = Todo(context: context)
        newTodo.id = UUID()
        newTodo.title = title
        newTodo.isCompleted = false
        
        newTodo.dueTime = dueTime
        newTodo.placeName = placeName
        newTodo.group = group
        newTodo.timeAlarm = timeAlarm
        newTodo.placeAlarm = placeAlarm
        
        saveContext()
    }
    
    func readTodo(id: UUID) -> TodoType? {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let todos = try context.fetch(fetchRequest)
            guard let todo = todos.first else { return nil }
            
            var group: GroupType? = nil
            if let groupID = todo.group?.id,
               let title = todo.group?.title {
                group = GroupType(id: groupID,
                                  title: title,
                                  color: todo.group?.color,
                                  indexNumber: todo.group?.indexNumber,
                                  todo: nil)
            }
            
            var placeAlarm: PlaceAlarmType? = nil
            if let alarmID = todo.placeAlarm?.id,
               let distance = todo.placeAlarm?.distance,
               let latitude = todo.placeAlarm?.latitude,
               let longitude = todo.placeAlarm?.longitude {
                placeAlarm = PlaceAlarmType(id: alarmID,
                                            distance: distance,
                                            latitude: latitude,
                                            longitude: longitude,
                                            todo: nil)
            }
            
            var data: TodoType? = nil
            if let id = todo.id, let title = todo.title {
                data = TodoType(id: id,
                                title: title,
                                isCompleted: todo.isCompleted,
                                dueTime: todo.dueTime,
                                placeName: todo.placeName,
                                timeAlarm: todo.timeAlarm,
                                group: group,
                                placeAlarm: placeAlarm)
                
                group?.todo = data
                placeAlarm?.todo = data
            }
            
            return data
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
    
    func updateIsCompleted(id: UUID, status: Bool) {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            guard let todoToUpdate = results.first else {
                print("해당 ID를 가진 Todo를 찾을 수 없습니다.")
                return
            }
            
            todoToUpdate.isCompleted = status
            
            try context.save()
        } catch let error {
            print("투두 완료 여부 업데이트 실패: \(error.localizedDescription)")
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
    
    func updateGroup(group: Group, newTitle: String, newColor: String) {
        group.title = newTitle
        group.color = newColor
        
        saveContext()
    }
    
    func deleteGroup(group: Group) {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "group == %@", group as CVarArg)
        do {
            let todoInGroup = try context.fetch(fetchRequest)
            todoInGroup.forEach { context.delete($0) }
        } catch {
            print("투두 삭제 실패")
        }
        context.delete(group)
        
        saveContext()
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
