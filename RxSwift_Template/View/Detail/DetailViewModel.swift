//
//  DetailViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 17/01/2023.
//

import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

final class DetailViewModel {
    private(set) var productSubject: BehaviorRelay<Product?> = .init(value: Product())
    private(set) var listImage: BehaviorRelay<[ImageProduct]> = .init(value: [])
    private(set) var favoriteProducts: BehaviorRelay<[Product]?> = .init(value: [])
    
    var currentIndex: Int = 0

    private let bagModel: DisposeBag = DisposeBag()
    
    init(product: Product) {
        self.productSubject.accept(product)
        self.listImage.accept(product.images.toArray())
    }

    func viewModelForItem(at indexPath: IndexPath) -> CarouselCellViewModel {
        return CarouselCellViewModel(data: listImage.value[indexPath.row].image)
    }
}

//MARK: Handle RxRealm
extension DetailViewModel {
    func getProductInRealm() {
        let realm = try! Realm()
        let products = realm.objects(Product.self)
        Observable.array(from: products)
            .subscribe(onNext: { [weak self] products  in
                guard let this = self else { return }
                this.favoriteProducts.accept(products)
            })
            .disposed(by: bagModel)
    }

    func addProductInRealm() {
        let realm = try! Realm()
        Observable.from(object: self.productSubject.value ?? Product())
            .subscribe(realm.rx.add())
            .disposed(by: bagModel)
        print("ADD", realm.objects(Product.self).toArray())
    }

    func deleteProductInRealm() {
        let realm = try! Realm()
        let product = realm.objects(Product.self).filter("id = %@", self.productSubject.value?.id as Any)
        Observable.collection(from: product)
            .subscribe(realm.rx.delete())
            .disposed(by: bagModel)
        print("ADDddđ", realm.objects(Product.self).toArray())
    }

    func isFavorite(product: Product) -> Observable<Bool> {
        getProductInRealm()
        guard let fvP = favoriteProducts.value else { return .just(false) }
        for favoriteProduct in fvP where favoriteProduct.id == product.id {
            return .just(true)
        }
        return .just(false)
    }
}
