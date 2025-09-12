//
//  AppDelegate.swift
//  FirstProject
//
//  Created by Zack-Zeng on 2025/9/5.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let vc = UITabBarController()
        vc.viewControllers = [EnergyStatsViewController(), RealtimeSceneViewController(), BatteryViewController()]
        window.rootViewController = vc
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

