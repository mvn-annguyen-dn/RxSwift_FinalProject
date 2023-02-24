//
//  FavoriteViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 10/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoriteViewModel {
    
    private var bag: DisposeBag = DisposeBag()

    var favoriteProducts: BehaviorRelay<[Product]> = .init(value: [])
    
    func viewModelForItem(index: Int) -> FavoriteTableCellViewModel {
        return FavoriteTableCellViewModel(favoriteProduct: favoriteProducts.value[index])
    }

    func dummyData() {
        let favoriteProducts: Product = Product()
        favoriteProducts.imageProduct = "https://cdn.tgdd.vn/Files/2019/07/25/1181734/do-sau-truong-anh-la-gi-cach-thiet-lap-de-chup-anh-dep-nhat--1.jpg"
        favoriteProducts.name = "Favorite test"
        self.favoriteProducts.accept([favoriteProducts])
    }
}
