//
//  AppDelegate.swift
//  RxSwift_Template
//
//  Created by An Nguyen Q. VN.Danang on 29/11/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        // Provide your apps root view controller
        let naviVC = UINavigationController(rootViewController: HomeViewController())
        window?.rootViewController = naviVC
        window?.makeKeyAndVisible()
        return true
    }
}

