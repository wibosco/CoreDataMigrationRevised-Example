//
//  CoreDataMigrationVersionTests.swift
//  CoreDataMigration-ExampleTests
//
//  Created by William Boles on 15/04/2026.
//  Copyright © 2026 William Boles. All rights reserved.
//

import XCTest

@testable import CoreDataMigration_Example

class CoreDataMigrationVersionTests: XCTestCase {
    
    // MARK: - Tests
    
    // MARK: - RawValue
    
    func test_givenVersion1_ThenRawValueIsCorrect() {
        XCTAssertEqual(CoreDataMigrationVersion.version1.rawValue, "CoreDataMigration_Example")
    }
    
    func test_givenVersion2_ThenRawValueIsCorrect()  {
        XCTAssertEqual(CoreDataMigrationVersion.version2.rawValue, "CoreDataMigration_Example 2")
    }
    
    func test_givenVersion3_ThenRawValueIsCorrect()  {
        XCTAssertEqual(CoreDataMigrationVersion.version3.rawValue, "CoreDataMigration_Example 3")
    }
    
    func test_givenVersion4_ThenRawValueIsCorrect()  {
        XCTAssertEqual(CoreDataMigrationVersion.version4.rawValue, "CoreDataMigration_Example 4")
    }
    
    // MARK: - NextVersion
    
    func test_givenVersion1_whenNextVersionIsCalled_thenCorrectVersionIsReturned() {
        let nextVersion = CoreDataMigrationVersion.version1.nextVersion()
        
        XCTAssertEqual(nextVersion, .version2)
    }
    
    func test_givenVersion2_whenNextVersionIsCalled_thenCorrectVersionIsReturned() {
        let nextVersion = CoreDataMigrationVersion.version2.nextVersion()
        
        XCTAssertEqual(nextVersion, .version3)
    }
    
    func test_givenVersion3_whenNextVersionIsCalled_thenCorrectVersionIsReturned() {
        let nextVersion = CoreDataMigrationVersion.version3.nextVersion()
        
        XCTAssertEqual(nextVersion, .version4)
    }
    
    func test_givenVersion4_whenNextVersionIsCalled_thenCorrectVersionIsReturned() {
        let nextVersion = CoreDataMigrationVersion.version4.nextVersion()
        
        XCTAssertNil(nextVersion)
    }
    
    // MARK: - Latest

    func test_whenCurrentIsCalled_ThenVersion4IsReturned() throws {
        XCTAssertEqual(try CoreDataMigrationVersion.current(), .version4)
    }
}
