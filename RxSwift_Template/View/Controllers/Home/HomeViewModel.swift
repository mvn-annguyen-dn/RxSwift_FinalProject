//
//  HomeViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 03/02/2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class HomeViewModel {
    
    private var bag: DisposeBag = DisposeBag()
    /// multiple sections
    var sectionModels: BehaviorRelay<[HomeSectionModelType]> = .init(value: [])
    var apiErrorMessage: PublishSubject<ApiError> = .init()
    
    func getApiMultiTarget() {
        let shopObservable = ApiNetWorkManager.shared
            .request(ShopResponse.self, .target(MainTarget.shop))
            .asObservable()
        let recommnedObservable = ApiNetWorkManager.shared
            .request(ProductResponse.self, .target(MainTarget.recommend))
            .asObservable()
        let popularObservable = ApiNetWorkManager.shared
            .request(ProductResponse.self, .target(MainTarget.popular))
            .asObservable()
        
        let observable = Observable.zip(shopObservable, recommnedObservable, popularObservable)
        
        observable.subscribe(onNext: { shop, recommend, popular in
            self.sectionModels.accept([.init(items: [.slider(shop: shop.data ?? []), .recommend(recommendProducts: recommend.data ?? []), .popular(popularProducts: popular.data ?? [])])])
        }, onError: { error in
            self.apiErrorMessage.onNext(error as? ApiError ?? .invalidResponse )
        })
        .disposed(by: bag)
    }
    
    func viewModelForSlider(shop: [Shop]) -> SliderCellViewModel {
        return SliderCellViewModel(shops: shop)
    }
    
    func viewModelForRecommend(recommendProduct: [Product]) -> RecommendCellViewModel {
        return RecommendCellViewModel(recommends: recommendProduct)
    }
    
    func viewModelForPopular(popularProduct: [Product]) -> PopularCellViewModel {
        return PopularCellViewModel(populars: popularProduct)
    }

}
