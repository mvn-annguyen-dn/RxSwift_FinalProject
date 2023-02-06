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

        // Custom Style For Tabbar
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = .init(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
        tabBar.tintColor = .red
        
        self.viewControllers = [homeNavigationController]
    }
}
