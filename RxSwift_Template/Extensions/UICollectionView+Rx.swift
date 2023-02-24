//
//  UICollectionView+Rx.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 21/02/2023.
//

import RxSwift

extension Reactive where Base: UICollectionView {
    var scrollToItem: Binder<IndexPath> {
        return Binder(self.base) { cv, indexPath in
            cv.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
