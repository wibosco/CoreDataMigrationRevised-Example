//
//  CoreDataMigrator.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 11/09/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import CoreData

protocol CoreDataMigrating {
    func requiresMigration(at storeURL: URL, toVersion version: CoreDataMigrationVersion) throws -> Bool
    func migrateStore(at storeURL: URL, toVersion version: CoreDataMigrationVersion) throws
}

class CoreDataMigrator: CoreDataMigrating {
    
    // MARK: - Check
    
    func requiresMigration(at storeURL: URL,
                           toVersion version: CoreDataMigrationVersion) throws -> Bool {
        guard let metadata = try? NSPersistentStoreCoordinator.metadata(at: storeURL) else {
            return false
        }
        let compatiableVersion = try CoreDataMigrationVersion.compatibleVersionForStoreMetadata(metadata)
        
        return compatiableVersion != version
    }
    
    // MARK: - Migration
    
    func migrateStore(at storeURL: URL,
                      toVersion version: CoreDataMigrationVersion) throws {
        try forceWALCheckpointingForStore(at: storeURL)
        
        var currentURL = storeURL
        let migrationSteps = try self.migrationStepsForStore(at: storeURL,
                                                             toVersion: version)
        
        for migrationStep in migrationSteps {
            let manager = NSMigrationManager(sourceModel: migrationStep.sourceModel,
                                             destinationModel: migrationStep.destinationModel)
            let tmpDirectory = URL(fileURLWithPath: NSTemporaryDirectory(),
                                   isDirectory: true)
            let destinationURL = tmpDirectory.appendingPathComponent(UUID().uuidString)
            
            do {
                try manager.migrateStore(from: currentURL,
                                         sourceType: NSSQLiteStoreType,
                                         options: nil,
                                         with: migrationStep.mappingModel,
                                         toDestinationURL: destinationURL,
                                         destinationType: NSSQLiteStoreType,
                                         destinationOptions: nil)
            } catch let error {
                throw CoreDataMigrationError.migrationFailed(error)
            }
            
            if currentURL != storeURL {
                //Destroy intermediate step's store
                try NSPersistentStoreCoordinator.destroyStore(at: currentURL)
            }
            
            currentURL = destinationURL
        }
        
        try NSPersistentStoreCoordinator.replaceStore(at: storeURL,
                                                      withStoreAt: currentURL)
        
        if currentURL != storeURL {
            try NSPersistentStoreCoordinator.destroyStore(at: currentURL)
        }
    }
    
    private func migrationStepsForStore(at storeURL: URL,
                                        toVersion destinationVersion: CoreDataMigrationVersion)  throws -> [CoreDataMigrationStep] {
        let metadata = try NSPersistentStoreCoordinator.metadata(at: storeURL)
        let sourceVersion = try CoreDataMigrationVersion.compatibleVersionForStoreMetadata(metadata)
        
        return try migrationSteps(fromSourceVersion: sourceVersion,
                                  toDestinationVersion: destinationVersion)
    }

    private func migrationSteps(fromSourceVersion sourceVersion: CoreDataMigrationVersion,
                                toDestinationVersion destinationVersion: CoreDataMigrationVersion) throws -> [CoreDataMigrationStep] {
        var sourceVersion = sourceVersion
        var migrationSteps = [CoreDataMigrationStep]()

        while sourceVersion != destinationVersion, let nextVersion = sourceVersion.nextVersion() {
            let migrationStep = try CoreDataMigrationStep(sourceVersion: sourceVersion,
                                                          destinationVersion: nextVersion)
            migrationSteps.append(migrationStep)

            sourceVersion = nextVersion
        }

        return migrationSteps
    }
    
    // MARK: - WAL

    func forceWALCheckpointingForStore(at storeURL: URL) throws {
        let metadata = try NSPersistentStoreCoordinator.metadata(at: storeURL)
        guard let currentModel = NSManagedObjectModel.compatibleModelForStoreMetadata(metadata) else {
            throw CoreDataMigrationError.walCheckpointingMissingCompatibleModel
        }
        
        do {
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: currentModel)
            
            let options = [NSSQLitePragmasOption: ["journal_mode": "DELETE"]]
            let store = try persistentStoreCoordinator.addPersistentStore(at: storeURL,
                                                                          options: options)
            try persistentStoreCoordinator.remove(store)
        } catch let error {
            throw CoreDataMigrationError.walCheckpointingFailed(error)
        }
    }
}

private extension CoreDataMigrationVersion {
    
    // MARK: - Compatible
    
    static func compatibleVersionForStoreMetadata(_ metadata: [String : Any]) throws -> CoreDataMigrationVersion {
        let compatibleVersion = CoreDataMigrationVersion.allCases.first {
            guard let model = try? NSManagedObjectModel.managedObjectModel(forResource: $0.rawValue) else {
                return false
            }
            
            return model.isConfiguration(withName: nil,
                                         compatibleWithStoreMetadata: metadata)
        }
        
        guard let compatibleVersion = compatibleVersion else {
            throw CoreDataMigrationError.versionUnknown
        }
        
        return compatibleVersion
    }
}
