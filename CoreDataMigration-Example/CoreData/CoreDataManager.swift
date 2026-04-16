//
//  CoreDataManager.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 11/09/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    let migrator: CoreDataMigrating
    private let storeType: String
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "CoreDataMigration_Example")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.shouldInferMappingModelAutomatically = false //inferred mapping will be handled else where
        description?.shouldMigrateStoreAutomatically = false
        description?.type = storeType
        
        return persistentContainer
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return context
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        
        return context
    }()
    
    // MARK: - Singleton
    
    static let shared = CoreDataManager()
    
    // MARK: - Init
    
    init(storeType: String = NSSQLiteStoreType,
         migrator: CoreDataMigrating = CoreDataMigrator()) {
        self.storeType = storeType
        self.migrator = migrator
    }
    
    // MARK: - SetUp
    
    func setup(completion: @escaping (Result<Void, Error>) -> Void) {
        loadPersistentStore { result in
            completion(result)
        }
    }
    
    // MARK: - Loading
    
    private func loadPersistentStore(completion: @escaping (Result<Void, Error>) -> Void) {
        migrateStoreIfNeeded { result in
            guard case .success = result else {
                completion(result)
                return
            }
            
            self.persistentContainer.loadPersistentStores { _, error in
                guard let error = error else {
                    completion(.success(Void()))
                    return
                }
                
                completion(.failure(CoreDataError.persistentStoreLoadFailed(error)))
            }
        }
    }
    
    private func migrateStoreIfNeeded(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let storeURL = persistentContainer.persistentStoreDescriptions.first?.url else {
            completion(.failure(CoreDataError.persistentContainerNotSetup))
            return
        }
        
        do {
            let currentVersion = try CoreDataMigrationVersion.current()
            let requiresMigration = try migrator.requiresMigration(at: storeURL,
                                                                   toVersion: currentVersion)
            
            guard requiresMigration else {
                completion(.success(Void()))
                return
            }
            
            migrateStore(storeURL: storeURL,
                         toVersion: currentVersion,
                         completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    private func migrateStore(storeURL: URL,
                              toVersion version: CoreDataMigrationVersion,
                              completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try self.migrator.migrateStore(at: storeURL,
                                               toVersion: version)
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(Void()))
            }
        }
    }
}

