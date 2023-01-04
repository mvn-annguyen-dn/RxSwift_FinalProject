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
        case tabbar
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
        window?.makeKeyAndVisible()
        setRoot(root: .login)
        return true
    }

    private func setRootLogin() {
        let vc = CaseTwoViewController()
        let navi = UINavigationController(rootViewController: vc)
        window?.rootViewController = navi
    }

    private func setRootTabbar() {
        configTabbar()
        window?.rootViewController = tabbarController
    }

    func setRoot(root: RootType) {
        switch root {
        case .login:
            setRootLogin()
        case .tabbar:
            setRootTabbar()
        }
    }

    private func configTabbar() {
        let homeVC = HomeViewController()
        let homeNavi = UINavigationController(rootViewController: homeVC)
        homeNavi.tabBarItem = UITabBarItem(title: "BasicRxSwift", image: UIImage(systemName: "avatar_name"), tag: 1)
        tabbarController.setViewControllers([homeNavi], animated: true)
    }
}

