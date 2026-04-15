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
    
    func requiresMigration(at storeURL: URL,
                           toVersion version: CoreDataMigrationVersion) -> Bool {
        events.append(.requiresMigration(storeURL, version))
        
        return requiresMigrationToBeReturned
    }
    
    func migrateStore(at storeURL: URL,
                      toVersion version: CoreDataMigrationVersion) {
        events.append(.migrateStore(storeURL, version))
    }
}

