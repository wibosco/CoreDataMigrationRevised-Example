//
//  CoreDataMigrationStep.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 11/09/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import CoreData

struct CoreDataMigrationStep {
    let sourceModel: NSManagedObjectModel
    let destinationModel: NSManagedObjectModel
    let mappingModel: NSMappingModel
    
    // MARK: Init
    
    init(sourceVersion: CoreDataMigrationVersion,
         destinationVersion: CoreDataMigrationVersion) throws {
        let sourceModel = try NSManagedObjectModel.managedObjectModel(forResource: sourceVersion.rawValue)
        let destinationModel = try NSManagedObjectModel.managedObjectModel(forResource: destinationVersion.rawValue)
        
        guard let mappingModel = CoreDataMigrationStep.mappingModel(from: sourceModel,
                                                                    to: destinationModel) else {
            throw CoreDataMigrationError.mappingModelNotFound
        }
        
        self.sourceModel = sourceModel
        self.destinationModel = destinationModel
        self.mappingModel = mappingModel
    }
    
    // MARK: - Mapping
    
    private static func mappingModel(from sourceModel: NSManagedObjectModel,
                                     to destinationModel: NSManagedObjectModel) -> NSMappingModel? {
        return customMappingModel(from: sourceModel, to: destinationModel) ?? inferredMappingModel(from:sourceModel, to: destinationModel)
    }
    
    private static func inferredMappingModel(from sourceModel: NSManagedObjectModel,
                                             to destinationModel: NSManagedObjectModel) -> NSMappingModel? {
        return try? NSMappingModel.inferredMappingModel(forSourceModel: sourceModel,
                                                        destinationModel: destinationModel)
    }
    
    private static func customMappingModel(from sourceModel: NSManagedObjectModel,
                                           to destinationModel: NSManagedObjectModel) -> NSMappingModel? {
        return NSMappingModel(from: [Bundle.main],
                              forSourceModel: sourceModel,
                              destinationModel: destinationModel)
    }
}
