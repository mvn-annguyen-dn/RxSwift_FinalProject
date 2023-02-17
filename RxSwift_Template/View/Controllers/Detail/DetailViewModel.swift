//
//  DetailViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 10/02/2023.
//

import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

final class DetailViewModel {
    
    private(set) var productSubject: BehaviorRelay<Product?> = .init(value: Product())
    private(set) var listImage: BehaviorRelay<[ImageProduct]> = .init(value: [])
    private(set) var favoriteProducts: BehaviorRelay<[Product]?> = .init(value: [])
    
    var currentIndex: BehaviorRelay<Int> = .init(value: 0)
    
    private let bagModel: DisposeBag = DisposeBag()
    
    init(product: Product) {
        self.productSubject.accept(product)
        self.listImage.accept(Array(product.images))
    }
    
    func viewModelForItem(at indexPath: IndexPath) -> CarouselCellViewModel {
        return CarouselCellViewModel(data: listImage.value[indexPath.row].image)
    }
}

