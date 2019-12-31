//
//  AppDelegate.swift
//  StoryApp
//
//  Created by shivang on 28/12/19.
//  Copyright © 2019 iOS Developer. All rights reserved.
//

import UIKit
import Reachability

//===========there are some static predefined values for demo purpose only.=====...
struct Reachbility {
    static var status: InternetStatus = .unAvailable
}
enum LoginUser {
    static let userId = "11"
    static let userName = "shivang"
}

enum InternetStatus {
    case available
    case unAvailable // default value
}

//===================================================================================

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let mainNavigationController = UINavigationController()
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = mainNavigationController
        window?.makeKeyAndVisible()

        let mainCoordinator = Coordinator(mainNavigationController)
        mainCoordinator.start()
        _ = SyncManager.sharedManager
        return true
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        ReachabilityManager.sharedManager.startMonitoring()
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        ReachabilityManager.sharedManager.stopMonitoring()
    }
}
