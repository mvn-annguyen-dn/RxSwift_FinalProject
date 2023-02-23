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
    var rootType: RootType = .login

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        Session.shared.token.isEmpty ? (setRoot(rootType: .login)) : (setRoot(rootType: .home))
        window?.makeKeyAndVisible()
        return true
    }

    func setRoot(rootType: RootType) {
        switch rootType {
        case .login:
            changeRootToLogin()
        case .home:
            changeRootToHome()
        }
    }
    
    func changeRootToHome() {
        let tabbarController = BaseTabbarController()
        tabbarController.configTabbar()
        window?.rootViewController = tabbarController
    }
    
    func changeRootToLogin() {
        let loginVC = LoginViewController()
        loginVC.viewModel = LoginViewModel()
        window?.rootViewController = loginVC
    }
}
