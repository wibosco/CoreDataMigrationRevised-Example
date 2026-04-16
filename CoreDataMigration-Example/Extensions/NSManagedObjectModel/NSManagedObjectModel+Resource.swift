//
//  NSManagedObjectModel+Resource.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 02/01/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectModel {
    
    // MARK: - Resource
    
    static func managedObjectModel(forResource resource: String) throws -> NSManagedObjectModel {
        let mainBundle = Bundle.main
        let subdirectory = "CoreDataMigration_Example.momd"
        
        var omoURL: URL?
        if #available(iOS 11, *) {
            omoURL = mainBundle.url(forResource: resource,
                                    withExtension: "omo",
                                    subdirectory: subdirectory) // optimized model file
        }
        
        let momURL = mainBundle.url(forResource: resource,
                                    withExtension: "mom",
                                    subdirectory: subdirectory)
        
        guard let url = omoURL ?? momURL,
                let model = NSManagedObjectModel(contentsOf: url) else {
            throw CoreDataMigrationError.unableToLoadModel
        }
        
        return model
    }
}
