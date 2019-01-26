//
//  CoreDataMigratorTests.swift
//  CoreDataMigration-ExampleTests
//
//  Created by William Boles on 12/09/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import XCTest
import CoreData

@testable import CoreDataMigration_Example

class CoreDataMigratorTests: XCTestCase {
    
    var sut: CoreDataMigrator!
    
    // MARK: - Lifecycle
    
    override class func setUp() {
        super.setUp()
        
        FileManager.clearTempDirectoryContents()
    }
    
    override func setUp() {
        super.setUp()
        
        sut = CoreDataMigrator()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func tearDownCoreDataStack(context: NSManagedObjectContext) {
        context.destroyStore()
    }
    
    // MARK: - Tests
    
    // MARK: SingleStepMigrations
    
    func test_individualStepMigration_1to2() {
        let sourceURL = FileManager.moveFileFromBundleToTempDirectory(filename: "CoreDataMigration_Example_1.sqlite")
        let toVersion = CoreDataMigrationVersion.version2
        
        sut.migrateStore(at: sourceURL, toVersion: toVersion)
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: sourceURL.path))
        
        let model = NSManagedObjectModel.managedObjectModel(forResource: toVersion.rawValue)
        let context = NSManagedObjectContext(model: model, storeURL: sourceURL)
        let request = NSFetchRequest<NSManagedObject>.init(entityName: "Post")
        let sort = NSSortDescriptor(key: "postID", ascending: false)
        request.sortDescriptors = [sort]
        
        let migratedPosts = try? context.fetch(request)
        
        XCTAssertEqual(migratedPosts?.count, 10)
        
        let firstMigratedPost = migratedPosts?.first
        
        let migratedDate = firstMigratedPost?.value(forKey: "date") as? Date
        let migratedHexColor = firstMigratedPost?.value(forKey: "hexColor") as? String
        let migratedPostID = firstMigratedPost?.value(forKey: "postID") as? String
        let migratedContent = firstMigratedPost?.value(forKey: "content") as? String
        
        XCTAssertEqual(migratedDate?.timeIntervalSince1970, 1547494150.058821)
        XCTAssertEqual(migratedHexColor, "1BB732")
        XCTAssertEqual(migratedPostID, "FFFECB21-6645-4FDD-B8B0-B960D0E61F5A")
        XCTAssertEqual(migratedContent, "Test body")
        
        tearDownCoreDataStack(context: context)
    }
    
    func test_individualStepMigration_2to3() {
        let sourceURL = FileManager.moveFileFromBundleToTempDirectory(filename: "CoreDataMigration_Example_2.sqlite")
        let toVersion = CoreDataMigrationVersion.version3

        sut.migrateStore(at: sourceURL, toVersion: toVersion)

        XCTAssertTrue(FileManager.default.fileExists(atPath: sourceURL.path))

        let model = NSManagedObjectModel.managedObjectModel(forResource: toVersion.rawValue)
        let context = NSManagedObjectContext(model: model, storeURL: sourceURL)

        let postRequest = NSFetchRequest<NSManagedObject>.init(entityName: "Post")
        let postSort = NSSortDescriptor(key: "postID", ascending: false)
        postRequest.sortDescriptors = [postSort]

        let migratedPosts = try? context.fetch(postRequest)

        XCTAssertEqual(migratedPosts?.count, 10)

        let firstMigratedPost = migratedPosts?.first

        let migratedDate = firstMigratedPost?.value(forKey: "date") as? Date
        let migratedPostID = firstMigratedPost?.value(forKey: "postID") as? String
        let migratedHexColor = firstMigratedPost?.value(forKey: "hexColor") as? String
        let migratedPostSections = firstMigratedPost?.value(forKey: "sections") as? Set<NSManagedObject>

        XCTAssertEqual(migratedDate?.timeIntervalSince1970, 1547494150.058821)
        XCTAssertEqual(migratedPostID, "FFFECB21-6645-4FDD-B8B0-B960D0E61F5A")
        XCTAssertEqual(migratedHexColor, "1BB732")
        XCTAssertEqual(migratedPostSections?.count, 1)
        
        let migratedSection = migratedPostSections?.first
        
        let migratedBody = migratedSection?.value(forKey: "body") as? String
        let migratedIndex = migratedSection?.value(forKey: "index") as? Int
        let migratedTitle = migratedSection?.value(forKey: "title") as? String
        let migratedPost = migratedSection?.value(forKey: "post") as? NSManagedObject
        
        XCTAssertEqual(migratedTitle, "Test...")
        XCTAssertEqual(migratedBody, "Test body")
        XCTAssertEqual(migratedIndex, 0)
        
        XCTAssertNotNil(migratedPost)
        
        let contentRequest = NSFetchRequest<NSManagedObject>.init(entityName: "Section")

        let migratedSections = try? context.fetch(contentRequest)

        XCTAssertEqual(migratedSections?.count, 10)
        
        tearDownCoreDataStack(context: context)
    }

    func test_individualStepMigration_3to4() {
        let sourceURL = FileManager.moveFileFromBundleToTempDirectory(filename: "CoreDataMigration_Example_3.sqlite")
        let toVersion = CoreDataMigrationVersion.version4

        sut.migrateStore(at: sourceURL, toVersion: toVersion)

        XCTAssertTrue(FileManager.default.fileExists(atPath: sourceURL.path))

        let model = NSManagedObjectModel.managedObjectModel(forResource: toVersion.rawValue)
        let context = NSManagedObjectContext(model: model, storeURL: sourceURL)

        let postRequest = NSFetchRequest<NSManagedObject>.init(entityName: "Post")
        let postSort = NSSortDescriptor(key: "date", ascending: false)
        postRequest.sortDescriptors = [postSort]

        let migratedPosts = try? context.fetch(postRequest)

        XCTAssertEqual(migratedPosts?.count, 12)

        let firstMigratedPost = migratedPosts?.first

        let migratedDate = firstMigratedPost?.value(forKey: "date") as? Date
        let migratedPostID = firstMigratedPost?.value(forKey: "postID") as? String
        let migratedSoftDeleted = firstMigratedPost?.value(forKey: "softDeleted") as? Bool
        let migratedHexColor = firstMigratedPost?.value(forKey: "hexColor") as? String
        let migratedPostSections = firstMigratedPost?.value(forKey: "sections") as? Set<NSManagedObject>

        XCTAssertEqual(migratedDate?.timeIntervalSince1970, 1547764015.200076)
        XCTAssertEqual(migratedPostID, "7BC43935-3209-404E-836A-06F3C6518CB1")
        XCTAssertFalse(migratedSoftDeleted ?? true)
        XCTAssertEqual(migratedHexColor, "BAEFB6")
        XCTAssertEqual(migratedPostSections?.count, 2)
        
        let orderedMigratedSections = migratedPostSections?.sorted {
            let index1 = $0.value(forKey: "index") as! Int
            let index2 = $1.value(forKey: "index") as! Int
            return index1 < index2
        }
        
        let migratedSection = orderedMigratedSections?.first
        
        let migratedBody = migratedSection?.value(forKey: "body") as? String
        let migratedIndex = migratedSection?.value(forKey: "index") as? Int
        let migratedTitle = migratedSection?.value(forKey: "title") as? String
        let migratedPost = migratedSection?.value(forKey: "post") as? NSManagedObject
        
        let expectedBody = "Nam sapien nibh, ornare vitae cursus vehicula, pretium id nibh. Nunc nulla enim, mollis sed leo eu, maximus semper mi. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Duis faucibus, tortor vitae gravida tristique, dolor nibh faucibus lorem, at semper ex mi id felis. Mauris molestie mauris in feugiat aliquet. In quam ipsum, vestibulum ac purus eu, vulputate consectetur justo. Integer facilisis dictum risus, sit amet condimentum quam pulvinar nec. Curabitur blandit est ut libero lobortis malesuada. Morbi gravida arcu at ultrices commodo. Ut enim metus, viverra tincidunt turpis sit amet, consectetur pharetra urna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse ex massa, aliquam at leo quis, rhoncus accumsan nisl. Donec id porttitor massa."
        
        XCTAssertEqual(migratedTitle, "This post will have 2 sections")
        XCTAssertEqual(migratedBody, expectedBody)
        XCTAssertEqual(migratedIndex, 0)
        
        XCTAssertNotNil(migratedPost)
        
        let contentRequest = NSFetchRequest<NSManagedObject>.init(entityName: "Section")
        
        let migratedSections = try? context.fetch(contentRequest)
        
        XCTAssertEqual(migratedSections?.count, 14)

        tearDownCoreDataStack(context: context)
    }

    // MARK: MultipleStepMigrations

    func test_multipleStepMigration_fromVersion1toVersion4() {
        let sourceURL = FileManager.moveFileFromBundleToTempDirectory(filename: "CoreDataMigration_Example_1.sqlite")
        let toVersion = CoreDataMigrationVersion.version4

        sut.migrateStore(at: sourceURL, toVersion: toVersion)

        XCTAssertTrue(FileManager.default.fileExists(atPath: sourceURL.path))

        let model = NSManagedObjectModel.managedObjectModel(forResource: toVersion.rawValue)
        let context = NSManagedObjectContext(model: model, storeURL: sourceURL)

        let postRequest = NSFetchRequest<NSManagedObject>.init(entityName: "Post")
        let sectionRequest = NSFetchRequest<NSManagedObject>.init(entityName: "Section")

        let migratedPosts = try? context.fetch(postRequest)
        let migratedSections = try? context.fetch(sectionRequest)

        XCTAssertEqual(migratedPosts?.count, 10)
        XCTAssertEqual(migratedSections?.count, 10)

        tearDownCoreDataStack(context: context)
    }

    // MARK: MigrationRequired

    func test_requiresMigration_fromVersion1ToCurrent_true() {
        let storeURL = FileManager.moveFileFromBundleToTempDirectory(filename: "CoreDataMigration_Example_1.sqlite")

        let requiresMigration = sut.requiresMigration(at: storeURL, toVersion: CoreDataMigrationVersion.latest)

        XCTAssertTrue(requiresMigration)
    }

    func test_requiresMigration_fromVersion2ToVersion2_false() {
        let storeURL = FileManager.moveFileFromBundleToTempDirectory(filename: "CoreDataMigration_Example_2.sqlite")

        let requiresMigration = sut.requiresMigration(at: storeURL, toVersion: .version2)

        XCTAssertFalse(requiresMigration)
    }
}
