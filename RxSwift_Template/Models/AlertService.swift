//
//  Services.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 16/01/2023.
//

import UIKit
import RxSwift

protocol AlertActionType {
    var title: String? { get }
    var style: UIAlertAction.Style { get }
}

extension AlertActionType {
    var style: UIAlertAction.Style {
        return .default
    }
}

protocol AlertServiceType: AnyObject {
    func show<Action: AlertActionType>(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        actions: [Action]
    ) -> Observable<Action>
}

final class AlertService: UIViewController, AlertServiceType {

    static var shared: AlertService = AlertService()
    
    func show<Action>(title: String?,
                      message: String?,
                      preferredStyle: UIAlertController.Style,
                      actions: [Action]) -> RxSwift.Observable<Action> where Action : AlertActionType {
        return Observable.create { observer in
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            for action in actions {
                let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(action)
                    observer.onCompleted()
                }
                alert.addAction(alertAction)
            }
            self.present(alert, animated: true)
            return Disposables.create {
                alert.dismiss(animated: true)
            }
        }
    }
    
}
