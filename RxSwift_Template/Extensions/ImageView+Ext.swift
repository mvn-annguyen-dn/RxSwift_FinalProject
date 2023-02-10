//
//  ImageView+Ext.swift
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
            let config = URLSessionConfiguration.default
            config.waitsForConnectivity = true
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: url) { data, _, error in
                if let _ = error {
                    observer.onError(ApiError.parseError)
                } else {
                    if let data = data {
                        let image = UIImage(data: data)
                        observer.onNext(image)
                        observer.onCompleted()
                    } else {
                        observer.onError(ApiError.noData)
                    }
                }
            }
            task.resume()
            
            return Disposables.create() {
                task.cancel()
            }
        }
        .observe(on: MainScheduler.instance)
    }
}
