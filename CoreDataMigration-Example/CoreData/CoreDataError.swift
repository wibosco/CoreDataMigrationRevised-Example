//
//  CoreDataError.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 15/04/2026.
//  Copyright © 2026 William Boles. All rights reserved.
//

import Foundation

enum CoreDataError: Error {
    case persistentContainerNotSetup
    case persistentStoreLoadFailed(Error)
}
