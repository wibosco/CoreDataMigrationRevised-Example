//
//  NSPersistentStoreCoordinator+SQLite.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 15/09/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import CoreData

extension NSPersistentStoreCoordinator {
    
    // MARK: - Destroy
    
    static func destroyStore(at storeURL: URL) throws {
        do {
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel())
            try persistentStoreCoordinator.destroyPersistentStore(at: storeURL,
                                                                  ofType: NSSQLiteStoreType,
                                                                  options: nil)
        } catch let error {
            throw CoreDataMigrationError.storeDestructionFailed(error)
        }
    }
    
    // MARK: - Replace
    
    static func replaceStore(at targetURL: URL,
                             withStoreAt sourceURL: URL) throws {
        do {
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel())
            try persistentStoreCoordinator.replacePersistentStore(at: targetURL,
                                                                  destinationOptions: nil,
                                                                  withPersistentStoreFrom: sourceURL,
                                                                  sourceOptions: nil,
                                                                  ofType: NSSQLiteStoreType)
        } catch let error {
            throw CoreDataMigrationError.storeReplacementFailed(error)
        }
    }
    
    // MARK: - Meta
    
    static func metadata(at storeURL: URL) throws -> [String: Any]  {
        do {
            return try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType,
                                                                                at: storeURL,
                                                                                options: nil)
        } catch let error {
            throw CoreDataMigrationError.metadataUnknown(error)
        }

    }
    
    // MARK: - Add
    
    func addPersistentStore(at storeURL: URL,
                            options: [AnyHashable: Any]) throws -> NSPersistentStore {
        do {
            return try addPersistentStore(ofType: NSSQLiteStoreType,
                                          configurationName: nil,
                                          at: storeURL,
                                          options: options)
        } catch let error {
            throw CoreDataMigrationError.storeAdditionFailed(error)
        }
    }
}
