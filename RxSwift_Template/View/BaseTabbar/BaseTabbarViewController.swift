//
//  BaseTabbarViewController.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 02/02/2023.
//

import Foundation
import UIKit

final class BaseTabbarViewController: UITabBarController {

    func configTabbar() {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        let homeNavigationController = UINavigationController(rootViewController: homeVC)

        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = .init(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
        tabBar.tintColor = .red

        self.viewControllers = [homeNavigationController]
    }
}

