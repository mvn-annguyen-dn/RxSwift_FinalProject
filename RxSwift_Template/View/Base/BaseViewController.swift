//
//  BaseViewController.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 03/02/2023.
//

import UIKit

class BaseViewController: UIViewController {

    func normalAlert(message: String) {
        let alertVC = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alertVC.addAction(okButton)
        present(alertVC, animated: false)
    }

    func showTabbar() {
        tabBarController?.tabBar.rx.isHidden.onNext(false)
    }

    func hideTabbar() {
        tabBarController?.tabBar.rx.isHidden.onNext(true)
    }
}
