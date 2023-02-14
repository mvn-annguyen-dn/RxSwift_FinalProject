//
//  BaseTabbarController.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 06/02/2023.
//

import UIKit

final class BaseTabbarController: UITabBarController {

    func configTabbar() {
        // Create ViewController
        // Example: ExampleVC, HomeVC, SearchVC, ....
        let examVC = ExampleViewController()
        examVC.tabBarItem = UITabBarItem(title: "Example", image: UIImage(systemName: "house.fill"), tag: 0)
        let homeNavigationController = UINavigationController(rootViewController: examVC)

        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 3)
        profileVC.viewModel = ProfileViewModel()
        let profileNavigationController = UINavigationController(rootViewController: profileVC)

        // Custom Style For Tabbar
        tabBar.layer.rx
            .borderWidth
            .onNext(Define.borderWidth)
        tabBar.layer.rx
            .borderColor
            .onNext(Define.borderColor)
        tabBar.rx
            .tintColor
            .onNext(Define.tintColor)
        
        self.rx
            .viewControllers
            .onNext([homeNavigationController, profileNavigationController])
    }
}

extension BaseTabbarController {
    private struct Define {
        static var borderWidth: CGFloat = 1
        static var borderColor: CGColor = .init(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
        static var tintColor: UIColor = .red
    }
}
