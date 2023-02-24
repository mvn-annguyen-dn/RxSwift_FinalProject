//
//  FavoriteViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 10/02/2023.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

final class FavoriteViewModel {
    
    private var bag: DisposeBag = DisposeBag()
    var favoriteProducts: BehaviorRelay<[Product]> = .init(value: [])
    private(set) var favoriteProduct: BehaviorRelay<Product?> = .init(value: nil)
    var errorBehaviorRelay: PublishRelay<Error> = .init()
    
    func viewModelForItem(index: Int) -> FavoriteTableCellViewModel {
        return FavoriteTableCellViewModel(favoriteProduct: favoriteProducts.value[index])
    }
    
    func getProductInRealm() {
        let realm = try! Realm()
        let products = realm.objects(Product.self)
        Observable.array(from: products)
            .subscribe(onNext: { [weak self] products  in
                guard let this = self else { return }
                this.favoriteProducts.accept(products)
            })
            .disposed(by: bag)
    }
    
    func deleteProductInRealm(id: Int) {
        let realm = try! Realm()
        try! realm.write {
            let object = realm.objects(Product.self).filter("id = %@", id as Any)
            realm.delete(object)
        }
    }
    
    func isFavorite(product: Product) -> Observable<Bool> {
        getProductInRealm()
        for favoriteProduct in favoriteProducts.value where favoriteProduct.id == product.id {
            return .just(true)
        }
        return .just(false)
    }
    
    func dummyData() {
        let favoriteProducts: Product = Product()
        favoriteProducts.imageProduct = "https://cdn.tgdd.vn/Files/2019/07/25/1181734/do-sau-truong-anh-la-gi-cach-thiet-lap-de-chup-anh-dep-nhat--1.jpg"
        favoriteProducts.name = "Favorite test"
        self.favoriteProducts.accept([favoriteProducts])
    }
}
