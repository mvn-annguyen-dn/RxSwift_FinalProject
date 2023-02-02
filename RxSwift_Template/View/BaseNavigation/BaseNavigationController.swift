//
//  BaseNavigationController.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 02/02/2023.
//

import Foundation
import UIKit

enum NavigationType {
    case discovery
    case search
    case favorite
    case profile
    case detail
    case cart
    case payment

    var title: String {
        switch self {
        case .discovery:
            return "Discovery"
        case .search:
            return "Search"
        case .favorite:
            return "Favorites"
        case .profile:
            return "Profile"
        case .detail:
            return "Detail"
        case .cart:
            return "Cart"
        case .payment:
            return "Payment"
        }
    }
}

extension UIViewController {
    func setTitleNavigation(type: NavigationType) {
        self.navigationItem.title = type.title
    }

    func setPrefersLargeTitles(type: NavigationType) {
        self.navigationController?.navigationBar.prefersLargeTitles = type == .discovery
        self.navigationItem.largeTitleDisplayMode = .always
    }

    func setRightBarButton(imageString: String, tintColor: UIColor, action: Selector?) {
        let rightButton = UIBarButtonItem(image: UIImage(systemName: imageString), style: .plain, target: self, action: action)
        rightButton.tintColor = tintColor
        self.navigationItem.rightBarButtonItem = rightButton
    }

    func setLeftBarButton(imageString: String, tintColor: UIColor, action: Selector?) {
        let leftButton = UIBarButtonItem(image: UIImage(imageLiteralResourceName: imageString), style: .plain, target: self, action: action)
        leftButton.tintColor = tintColor
        self.navigationItem.leftBarButtonItem = leftButton
    }
}

