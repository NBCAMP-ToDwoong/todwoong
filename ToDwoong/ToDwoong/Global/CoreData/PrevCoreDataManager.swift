//
//  CoreDataManager.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 2/28/24.
//

//import CoreData
//import UIKit
//
//final class PrevCoreDataManager {
//    
//    // MARK: Singleton
//    
//    static let shared = CoreDataManager()
//    private var persistentContainer: NSPersistentContainer? {
//        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
//    }
//    var context: NSManagedObjectContext {
//        guard let persistentContainer = self.persistentContainer else {
//            fatalError("Persistent container is nil")
//        }
//        return persistentContainer.viewContext
//    }
//    
//    private init() {}
//    
//    // MARK: fetchRequest
//    
//    private let todoRequest = Todo.fetchRequest()
//    private let categoryRequest = Category.fetchRequest()
//    
//    // MARK: Todo Methods
//    
//    func createTodo(title: String,
//                    place: String?,
//                    dueDate: Date?, dueTime: Date?,
//                    isCompleted: Bool,
//                    timeAlarm: Bool, placeAlarm: Bool,
//                    category: Category?,
//                    fixed: Bool = false
//    ) {
//        let newTodo = Todo(context: context)
//        newTodo.id = UUID()
//        newTodo.title = title
//        newTodo.place = place
//        newTodo.dueDate = dueDate
//        newTodo.dueTime = dueTime
//        newTodo.isCompleted = isCompleted
//        newTodo.timeAlarm = timeAlarm
//        newTodo.placeAlarm = placeAlarm
//        newTodo.category = category
//        newTodo.fixed = fixed
//        saveContext()
//    }
//    
//    func readTodos() -> [Todo] {
//        do {
//            let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
//            let dueDateSortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
//            let dueTimeSortDescriptor = NSSortDescriptor(key: "dueTime", ascending: true)
//            fetchRequest.sortDescriptors = [dueDateSortDescriptor, dueTimeSortDescriptor]
//            
//            let todos = try context.fetch(fetchRequest)
//            return todos
//        } catch {
//            print("투두 불러오기 실패")
//            return []
//        }
//    }
//    
//    func updateTodo(todo: Todo, 
//                    newTitle: String, newPlace: String?,
//                    newDate: Date?, newTime: Date?,
//                    newCompleted: Bool,
//                    newTimeAlarm: Bool, newPlaceAlarm: Bool,
//                    newCategory: Category?
//    ) {
//        todo.title = newTitle
//        todo.place = newPlace
//        todo.dueDate = newDate
//        todo.dueTime = newTime
//        todo.isCompleted = newCompleted
//        todo.timeAlarm = newTimeAlarm
//        todo.placeAlarm = newPlaceAlarm
//        todo.category = newCategory
//        
//        saveContext()
//    }
//    
//    func deleteTodo(todo: Todo) {
//        context.delete(todo)
//        
//        saveContext()
//    }
//    
//    // MARK: Category Methods
//    
//    func createCategory(title: String, color: String) {
//        let newCategory = Category(context: context)
//        newCategory.id = UUID()
//        newCategory.title = title
//        newCategory.color = color
//        
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Category")
//        fetchRequest.resultType = .dictionaryResultType
//        let calculateDesc = NSExpressionDescription()
//        calculateDesc.name = "maxIndexNumber"
//        calculateDesc.expression = NSExpression(forFunction: "max:",
//                                                arguments: [NSExpression(forKeyPath: "indexNumber")])
//        calculateDesc.expressionResultType = .integer64AttributeType
//        fetchRequest.propertiesToFetch = [calculateDesc]
//
//        do {
//            let results = try context.fetch(fetchRequest)
//            if let maxIndexNumberDict = results.first as? [String: Int64],
//               let maxIndexNumber = maxIndexNumberDict["maxIndexNumber"] {
//                newCategory.indexNumber = Int32(maxIndexNumber + 1)
//            } else {
//                newCategory.indexNumber = 0
//            }
//        } catch let error as NSError {
//            print("Could not fetch maxIndexNumber: \(error), \(error.userInfo)")
//            newCategory.indexNumber = 0
//        }
//        
//        saveContext()
//    }
//    
//    func readCategories() -> [Category] {
//        do {
//            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
//            let sortDescriptor = NSSortDescriptor(key: "indexNumber", ascending: true)
//            fetchRequest.sortDescriptors = [sortDescriptor]
//            
//            let categories = try context.fetch(fetchRequest)
//            return categories
//        } catch {
//            print("카테고리 불러오기 실패")
//            return []
//        }
//    }
//    
//    func updateCategory(category: Category, newTitle: String, newColor: String) {
//        category.title = newTitle
//        category.color = newColor
//        
//        saveContext()
//    }
//    
//    func deleteCategory(category: Category) {
//        context.delete(category)
//        
//        saveContext()
//    }
//    
//    // MARK: Filter Todo
//    
//    func filterTodoByCategory(category: Category) -> [Todo] {
//        do {
//            let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "category == %@", category)
//            let filteredTodos = try context.fetch(fetchRequest)
//            return filteredTodos
//        } catch {
//            print("투두 필터링 실패: \(error.localizedDescription)")
//            return []
//        }
//    }
//    
//    func filterTodoByDuedate(_ date: Date) -> [Todo] {
//        let calendar = Calendar.current
//        let startOfDay = calendar.startOfDay(for: date)
//        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
//
//        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
//        let dueDatePredicate = NSPredicate(format: "(dueDate >= %@) AND (dueDate < %@)",
//                                           startOfDay as NSDate,
//                                           endOfDay as NSDate)
//        fetchRequest.predicate = dueDatePredicate
//
//        let sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        do {
//            let todos = try context.fetch(fetchRequest)
//            return todos
//        } catch {
//            print("Error fetching todos for date: \(error)")
//            return []
//        }
//    }
//    
//    // Overlap Logic
//    
//    func saveContext() {
//        do {
//            try context.save()
//        } catch {
//            context.rollback()
//            print("오류가 발생하였습니다. \(error.localizedDescription)")
//        }
//    }
//}
