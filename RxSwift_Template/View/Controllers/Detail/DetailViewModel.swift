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
    private(set) var statusResponse: PublishRelay<String?> = .init()
    private(set) var errorResponse: PublishRelay<ApiError?> = .init()
    
    var currentIndex: BehaviorRelay<Int> = .init(value: 0)
    
    private let bagModel: DisposeBag = DisposeBag()
    
    init(product: Product) {
        self.productSubject.accept(product)
        self.listImage.accept(Array(product.images))
    }
    
    func requestAddToCart(quantity: Int) {
        ApiNetWorkManager.shared
            .request(MessageResponse.self, .target(MainTarget.addCart(id: self.productSubject.value?.id ?? 0, quantity: quantity)))
            .subscribe(onSuccess: { [weak self] response in
                guard let this = self else { return }
                this.statusResponse.accept(response.data)
            }, onFailure: { error in
                self.errorResponse.accept(error as? ApiError ?? .unknown)
            })
            .disposed(by: bagModel)
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
        let product = Product(value: self.productSubject.value ?? Product())
        Observable.from(object: product)
            .subscribe(realm.rx.add())
            .disposed(by: bagModel)
    }
    
    func deleteProductInRealm() {
        let realm = try! Realm()
        try! realm.write {
            let object = realm.objects(Product.self).filter("id = %@", self.productSubject.value?.id as Any)
            realm.delete(object)
        }
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
