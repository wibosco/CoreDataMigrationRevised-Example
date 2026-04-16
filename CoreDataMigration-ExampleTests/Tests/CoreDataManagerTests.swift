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
        sut.setup { result in
            guard case .success = result else {
                XCTFail("Expected success")
                return
            }
            
            XCTAssertTrue(self.sut.persistentContainer.persistentStoreCoordinator.persistentStores.count > 0)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }

    func test_givenNoMigrationRequired_whenSetup_thenChecksIfMigrationRequiredButDoesNotMigrate() {
        migrator.requiresMigrationToBeReturned = false
        
        let expectation = expectation(description: "calls back")
        sut.setup { result in
            guard case .success = result else {
                XCTFail("Expected success")
                return
            }
            
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
        sut.setup { result in
            guard case .success = result else {
                XCTFail("Expected success")
                return
            }
            
            let hasMigrateStoreEvent = self.migrator.events.contains { event in
                if case .migrateStore = event { return true }
                return false
            }
            
            XCTAssertTrue(hasMigrateStoreEvent)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    // MARK: - Error
    
    func test_givenRequiresMigrationThrows_whenSetup_thenCompletesWithFailure() {
        migrator.requiresMigrationToBeReturned = false
        migrator.requiresMigrationErrorToBeThrown = CoreDataMigrationError.versionUnknown
        
        let expectation = expectation(description: "calls back")
        sut.setup { result in
            guard case .failure(let error) = result else {
                XCTFail("Expected failure")
                return
            }
            
            XCTAssertTrue(error is CoreDataMigrationError)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func test_givenMigrateStoreThrows_whenSetup_thenCompletesWithFailure() {
        migrator.requiresMigrationToBeReturned = true
        migrator.migrateStoreErrorToBeThrown = CoreDataMigrationError.migrationFailed(NSError(domain: "test", code: 1))
        
        let expectation = expectation(description: "calls back")
        sut.setup { result in
            guard case .failure(let error) = result else {
                XCTFail("Expected failure")
                return
            }
            
            XCTAssertTrue(error is CoreDataMigrationError)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
}
