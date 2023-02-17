//
//  UIImageView+Ext.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 03/02/2023.
//

import UIKit
import RxSwift

extension UIImageView {
    public static func dowloadImageWithRxSwift(url: String) -> Observable<UIImage?> {
        return Observable.create { observer in
            guard let url = URL(string: url) else {
                observer.onError(ApiError.noData)
                return Disposables.create()
            }
            let urlRequest = URLRequest(url: url)
            return URLSession.shared.rx.response(request: urlRequest).debug()
                .subscribe(onNext: { data in
                    let image = UIImage(data: data.data)
                    observer.onNext(image)
                }, onError: { _ in
                    observer.onError(ApiError.noData)
                }, onCompleted: {
                    observer.onCompleted()
                })
        }
        .observe(on: MainScheduler.instance)
    }
}
