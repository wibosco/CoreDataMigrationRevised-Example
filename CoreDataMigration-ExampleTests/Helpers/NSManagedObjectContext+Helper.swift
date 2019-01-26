//
//  NSManagedObjectContext+Helper.swift
//  CoreDataMigration-ExampleTests
//
//  Created by William Boles on 05/01/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    // MARK: Model
    
    convenience init(model: NSManagedObjectModel, storeURL: URL) {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        
        self.init(concurrencyType: .mainQueueConcurrencyType)
        
        self.persistentStoreCoordinator = persistentStoreCoordinator
    }
    
    // MARK: - Destroy
    
    func destroyStore() {
        persistentStoreCoordinator?.persistentStores.forEach {
            try? persistentStoreCoordinator?.remove($0)
            try? persistentStoreCoordinator?.destroyPersistentStore(at: $0.url!, ofType: $0.type, options: nil)
        }
    }
}
