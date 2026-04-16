//
//  AppDelegate.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 11/09/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - AppLifecycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard ProcessInfo.processInfo.environment["runningTests"] == nil else {
            FileManager.clearApplicationSupportDirectoryContents()
            return true
        }
        
        CoreDataManager.shared.setup { result in
            guard case let .failure(error) = result else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // just for example purposes
                    self.presentMainUI()
                }
                
                return
            }
            
            fatalError("Unable to set up Core Data stack: \(error)")
        }
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        try? CoreDataManager.shared.mainContext.save()
    }
    
    // MARK: - Main
    
    func presentMainUI() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        window?.rootViewController = mainStoryboard.instantiateInitialViewController()
    }
}

