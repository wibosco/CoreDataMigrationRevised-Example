//
//  MockCoreDataMigrator.swift
//  CoreDataMigration-ExampleTests
//
//  Created by William Boles on 02/01/2019.
//  Copyright © 2017 William Boles. All rights reserved.
//

import Foundation
import CoreData

@testable import CoreDataMigration_Example

class MockCoreDataMigrator: CoreDataMigratorProtocol {
    
    var requiresMigrationWasCalled = false
    var migrateStoreWasCalled = false
    
    var requiresMigrationToBeReturned = false
    
    // MARK: - CoreDataMigratorProtocol
    
    func requiresMigration(at: URL, toVersion: CoreDataMigrationVersion) -> Bool {
        requiresMigrationWasCalled = true
        
        return requiresMigrationToBeReturned
    }
    
    func migrateStore(at storeURL: URL, toVersion version: CoreDataMigrationVersion) {
        migrateStoreWasCalled = true
    }
}
