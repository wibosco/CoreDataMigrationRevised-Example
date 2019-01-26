//
//  FileManager+Helper.swift
//  CoreDataMigration-ExampleTests
//
//  Created by William Boles on 05/01/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import Foundation

extension FileManager {
    
    // MARK: - Temp
    
    static func clearTempDirectoryContents() {
        let tmpDirectoryContents = try! FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory())
        tmpDirectoryContents.forEach {
            let fileURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent($0)
            try? FileManager.default.removeItem(atPath: fileURL.path)
        }
    }
    
    static func moveFileFromBundleToTempDirectory(filename: String) -> URL {
        let destinationURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: destinationURL)
        let bundleURL = Bundle(for: CoreDataMigratorTests.self).resourceURL!.appendingPathComponent(filename)
        try? FileManager.default.copyItem(at: bundleURL, to: destinationURL)
        
        return destinationURL
    }
}
