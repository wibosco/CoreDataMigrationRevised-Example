//
//  StubCoreDataMigrator.swift
//  CoreDataMigration-ExampleTests
//
//  Created by William Boles on 15/04/2026.
//  Copyright © 2026 William Boles. All rights reserved.
//

import Foundation
import CoreData

@testable import CoreDataMigration_Example

class StubCoreDataMigrator: CoreDataMigrating {
    enum Event {
        case requiresMigration(URL, CoreDataMigrationVersion)
        case migrateStore(URL, CoreDataMigrationVersion)
    }
    
    private(set) var events: [Event] = []
    
    var requiresMigrationToBeReturned: Bool!
    var requiresMigrationErrorToBeThrown: Error?
    var migrateStoreErrorToBeThrown: Error?
    
    func requiresMigration(at storeURL: URL,
                           toVersion version: CoreDataMigrationVersion) throws -> Bool {
        events.append(.requiresMigration(storeURL, version))
        
        if let error = requiresMigrationErrorToBeThrown {
            throw error
        }
        
        return requiresMigrationToBeReturned
    }
    
    func migrateStore(at storeURL: URL,
                      toVersion version: CoreDataMigrationVersion) throws {
        events.append(.migrateStore(storeURL, version))
        
        if let error = migrateStoreErrorToBeThrown {
            throw error
        }
    }
}

