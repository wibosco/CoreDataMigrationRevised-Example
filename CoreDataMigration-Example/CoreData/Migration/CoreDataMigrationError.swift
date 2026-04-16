//
//  MigrationError.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 15/04/2026.
//  Copyright © 2026 William Boles. All rights reserved.
//

import Foundation

enum CoreDataMigrationError: Error {
    case modelNotFound
    case mappingModelNotFound
    case walCheckpointingFailed(Error)
    case walCheckpointingMissingCompatibleModel
    case storeUnknown
    case versionUnknown
    case metadataUnknown(Error)
    case migrationFailed(Error)
    case storeDestructionFailed(Error)
    case storeReplacementFailed(Error)
    case storeAdditionFailed(Error)
    case unableToLoadModel
}
