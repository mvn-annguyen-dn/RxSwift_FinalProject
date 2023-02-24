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
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        let homeNavigationController = UINavigationController(rootViewController: homeVC)
        
        let favoriteVC = FavoriteViewController()
        favoriteVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.fill"), tag: 2)
        favoriteVC.viewModel = FavoriteViewModel()
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteVC)

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
            .onNext([homeNavigationController, favoriteNavigationController])
    }
}

extension BaseTabbarController {
    private struct Define {
        static var borderWidth: CGFloat = 1
        static var borderColor: CGColor = .init(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
        static var tintColor: UIColor = .red
    }
}
