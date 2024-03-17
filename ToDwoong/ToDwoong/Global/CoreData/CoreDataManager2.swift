//
//  CoreDataManager2.swift
//  ToDwoong
//
//  Created by yen on 3/17/24.
//

import Foundation
import CoreData

class CoreDataManager2 {
    
    static var shared: CoreDataManager = CoreDataManager()
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { (description, error) in
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
    
}
