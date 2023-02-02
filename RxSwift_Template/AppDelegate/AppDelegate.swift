//
//  AppDelegate.swift
//  RxSwift_Template
//
//  Created by An Nguyen Q. VN.Danang on 29/11/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    enum RootType {
        case login
        case home
    }

    static var shared: AppDelegate = {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get AppDelegate")
        }
        return delegate
    }()

    var window: UIWindow?
    let tabbarController = UITabBarController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = ExampleViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }
}
