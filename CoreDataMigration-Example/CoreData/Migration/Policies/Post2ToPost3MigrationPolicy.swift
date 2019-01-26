//
//  PostToColorV3MigrationPolicy.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 12/09/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import CoreData

final class Post2ToPost3MigrationPolicy: NSEntityMigrationPolicy {
    
    override func createDestinationInstances(forSource sourceInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        try super.createDestinationInstances(forSource: sourceInstance, in: mapping, manager: manager)

        guard let destinationPost = manager.destinationInstances(forEntityMappingName: mapping.name, sourceInstances: [sourceInstance]).first else {
            fatalError("was expected a post")
        }
        
        let sourceBody = sourceInstance.value(forKey: "content") as? String
        let sourceTitle = sourceBody?.prefix(4).appending("...")
        
        let section = NSEntityDescription.insertNewObject(forEntityName: "Section", into: destinationPost.managedObjectContext!)
        section.setValue(sourceTitle, forKey: "title")
        section.setValue(sourceBody, forKey: "body")
        section.setValue(destinationPost, forKey: "post")
        section.setValue(0, forKey: "index")
        
        var sections = Set<NSManagedObject>()
        sections.insert(section)

        destinationPost.setValue(sections, forKey: "sections")
    }
}
