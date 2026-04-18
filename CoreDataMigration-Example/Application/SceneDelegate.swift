//
//  SceneDelegate.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 11/09/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // MARK: - SceneLifecycle

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard ProcessInfo.processInfo.environment["runningTests"] == nil else {
            FileManager.clearApplicationSupportDirectoryContents()
            return
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
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        try? CoreDataManager.shared.mainContext.save()
    }

    // MARK: - Main

    func presentMainUI() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        window?.rootViewController = mainStoryboard.instantiateInitialViewController()
    }
}
