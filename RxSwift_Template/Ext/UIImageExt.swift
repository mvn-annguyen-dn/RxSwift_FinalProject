//
//  UIImageExt.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 04/01/2023.
//

import UIKit
import RxSwift

extension UIImage {

    public static func dowloadImageWithRxSwift(url: String) -> Observable<UIImage?> {
        return Observable.create { observer in
            guard let url = URL(string: url) else {
                observer.onError(ApiError.pathError)
                return Disposables.create()
            }
            let config = URLSessionConfiguration.default
            config.waitsForConnectivity = true
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: url) { data, _, error in
                if let _ = error {
                    observer.onError(ApiError.error("Data Image Fail"))
                } else {
                    if let data = data {
                        let image = UIImage(data: data)
                        observer.onNext(image)
                        observer.onCompleted()
                    } else {
                        observer.onError(ApiError.error("Data Image not found"))
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
