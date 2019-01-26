//
//  CoreDataVersion.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 02/01/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataMigrationVersion: String, CaseIterable {
    case version1 = "CoreDataMigration_Example"
    case version2 = "CoreDataMigration_Example 2"
    case version3 = "CoreDataMigration_Example 3"
    case version4 = "CoreDataMigration_Example 4"
    
    // MARK: - Latest
    
    static var latest: CoreDataMigrationVersion {
        guard let latest = allCases.last else {
            fatalError("no model versions found")
        }
        
        return latest
    }
    
    // MARK: - Migration
    
    func nextVersion() -> CoreDataMigrationVersion? {
        switch self {
        case .version1:
            return .version2
        case .version2:
            return .version3
        case .version3:
            return .version4
        case .version4:
            return nil
        }
    }
}
