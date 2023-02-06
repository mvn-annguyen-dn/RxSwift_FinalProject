//
//  AppDelegate.swift
//  RxSwift_Template
//
//  Created by An Nguyen Q. VN.Danang on 29/11/2022.
//

import UIKit

let ud = UserDefaults.standard

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = LoginViewController()
        vc.viewModel = LoginViewModel()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }
}
