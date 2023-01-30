//
//  Ext+ViewController.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 30/01/2023.
//

import Foundation
import UIKit
import RxSwift

extension UIViewController {
    public func showAlert(title: String, message: String) -> Completable {
        return Completable.create { observer in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: { _ in
                observer(.completed)
            })
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                observer(.completed)
            }
            alert.addAction(okButton)
            alert.addAction(cancelButton)
            self.present(alert, animated: true)
            return Disposables.create()
        }
    }
}
