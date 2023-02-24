//
//  FavoriteViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 10/02/2023.
//

import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

final class FavoriteViewModel {
    
    private var bag: DisposeBag = DisposeBag()
    var favoriteProducts: BehaviorRelay<[Product]> = .init(value: [])
    var errorBehaviorRelay: PublishRelay<Error> = .init()
    
    func viewModelForItem(index: Int) -> FavoriteTableCellViewModel {
        return FavoriteTableCellViewModel(favoriteProduct: favoriteProducts.value[safe: index])
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
}
