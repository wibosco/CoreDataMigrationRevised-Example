//
//  CoreDataManagerTests.swift
//  CoreDataMigration-ExampleTests
//
//  Created by William Boles on 15/09/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import XCTest
import CoreData

@testable import CoreDataMigration_Example

class CoreDataManagerTests: XCTestCase {
    var migrator: StubCoreDataMigrator!
    var sut: CoreDataManager!
    
    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
    
        migrator = StubCoreDataMigrator()
        sut = CoreDataManager(storeType: NSInMemoryStoreType,
                              migrator: migrator)
    }

    override func tearDown() {
        migrator = nil
        sut = nil
        
        super.tearDown()
    }

    // MARK: - Tests
    
    // MARK: - Setup
    
    func test_givenNoMigrationRequired_whenSetup_thenLoadsStore() {
        migrator.requiresMigrationToBeReturned = false
        
        let expectation = expectation(description: "calls back")
        sut.setup {
            XCTAssertTrue(self.sut.persistentContainer.persistentStoreCoordinator.persistentStores.count > 0)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }

    func test_givenNoMigrationRequired_whenSetup_thenChecksIfMigrationRequiredButDoesNotMigrate() {
        migrator.requiresMigrationToBeReturned = false
        
        let expectation = expectation(description: "calls back")
        sut.setup {
            let hasRequiresMigrationEvent = self.migrator.events.contains { event in
                if case .requiresMigration = event { return true }
                return false
            }
            let hasMigrateStoreEvent = self.migrator.events.contains { event in
                if case .migrateStore = event { return true }
                return false
            }
            
            XCTAssertTrue(hasRequiresMigrationEvent)
            XCTAssertFalse(hasMigrateStoreEvent)
            
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }
    
    func test_givenMigrationRequired_whenSetup_thenMigratesStore() {
        migrator.requiresMigrationToBeReturned = true
        
        let expectation = expectation(description: "calls back")
        sut.setup {
            let hasMigrateStoreEvent = self.migrator.events.contains { event in
                if case .migrateStore = event { return true }
                return false
            }
            
            XCTAssertTrue(hasMigrateStoreEvent)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
}
