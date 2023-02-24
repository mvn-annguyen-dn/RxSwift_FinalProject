//
//  SlideCollectionViewCellViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 09/02/2023.
//
import Foundation
import RxSwift
import RxCocoa

final class SlideCollectionViewCellViewModel {

    var shop: BehaviorRelay<Shop?> = .init(value: nil)
    
    init(shop: Shop?) {
        self.shop.accept(shop)
    }
}
