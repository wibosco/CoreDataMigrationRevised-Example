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
    
    var migrator: MockCoreDataMigrator!
    var sut: CoreDataManager!
    
    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
    
        migrator = MockCoreDataMigrator()
        sut = CoreDataManager(storeType: NSInMemoryStoreType, migrator: migrator)
    }

    override func tearDown() {
        migrator = nil
        sut = nil
        
        super.tearDown()
    }

    // MARK: - Tests
    
    // MARK: Setup
    
    func test_setup_loadsStore() {
        let promise = expectation(description: "calls back")
        sut.setup {
            XCTAssertTrue(self.sut.persistentContainer.persistentStoreCoordinator.persistentStores.count > 0)
            
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Timed out: \(String(describing: error))")
            }
        }
    }

    func test_setup_checksIfMigrationRequired() {
        let promise = expectation(description: "calls back")
        sut.setup {
            XCTAssertTrue(self.migrator.requiresMigrationWasCalled)
            XCTAssertFalse(self.migrator.migrateStoreWasCalled)
            
            promise.fulfill()
        }

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Timed out: \(String(describing: error))")
            }
        }
    }
    
    func test_setup_migrate() {
        migrator.requiresMigrationToBeReturned = true
        
        let promise = expectation(description: "calls back")
        sut.setup {
            XCTAssertTrue(self.migrator.migrateStoreWasCalled)
            
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Timed out: \(String(describing: error))")
            }
        }
    }
}
