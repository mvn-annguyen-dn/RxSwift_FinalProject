//
//  BaseNavigationController.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 07/02/2023.
//

import RxSwift

enum NavigationType {
    case example
    case favorite
    case detail

    var title: String {
        switch self {
        case .example:
            return "Example"
        case .favorite:
            return "Favorite"
        case .detail:
            return "Detail"
        }
    }
}

extension BaseViewController {
    func setTitleNavigation(type: NavigationType) {
        navigationItem.rx
            .title
            .onNext(type.title)
    }

    func setRightBarButton(imageString: String, tintColor: UIColor, action: Selector?) {
        let rightButton = UIBarButtonItem(image: UIImage(systemName: imageString), style: .plain, target: self, action: action)
        rightButton.rx
            .tintColor
            .onNext(tintColor)
        navigationItem.rx
            .rightBarButtonItem
            .onNext(rightButton)
    }

    func setLeftBarButton(imageString: String, tintColor: UIColor, action: Selector?) {
        let leftButton = UIBarButtonItem(image: UIImage(imageLiteralResourceName: imageString), style: .plain, target: self, action: action)
        leftButton.rx
            .tintColor
            .onNext(tintColor)
        navigationItem.rx
            .leftBarButtonItem
            .onNext(leftButton)
    }
}
