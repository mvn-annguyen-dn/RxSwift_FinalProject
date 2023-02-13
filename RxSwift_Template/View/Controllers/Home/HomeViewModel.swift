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
    var sectionModels: BehaviorRelay<[HomeSectionModel]> = .init(value: [])

    var shops: BehaviorRelay<[Shop]> = .init(value: [])
    var recommends: BehaviorRelay<[Product]> = .init(value: [])
    var populars: BehaviorRelay<[Product]> = .init(value: [])
    var errorBehaviorRelay: PublishRelay<ApiError> = .init()
        
    func fetchData() {
        let sections: [HomeSectionModel] = [
            
            .sectionSlider(items: [
                .slider(shop: shops.value)]),
            
            .sectionRecommend(items: [
                .recommend(recommendProducts: recommends.value)]),
            
            .sectionPopular(items: [
                .popular(popularProducts: populars.value)])
        ]
        
        sectionModels.accept(sections)
    }
    
    func getApiMultiTarget() {
        let shopObservable = ApiNetWorkManager.shared.request(ShopResponse.self, .target(MainTarget.shop)).asObservable()
        let recommnedObservable = ApiNetWorkManager.shared.request(ProductResponse.self, .target(MainTarget.recommend)).asObservable()
        let popularObservable = ApiNetWorkManager.shared.request(ProductResponse.self, .target(MainTarget.popular)).asObservable()
        
        let observable = Observable.zip(shopObservable, recommnedObservable, popularObservable)
        
        observable.subscribe(onNext: { shop, recommend, popular in
            self.shops.accept(shop.data ?? [])
            self.recommends.accept(recommend.data ?? [])
            self.populars.accept(popular.data ?? [])
            self.fetchData()
        }, onError: { error in
            self.errorBehaviorRelay.accept(error as? ApiError ?? .invalidResponse )
        })
        .disposed(by: bag)
    }
    
    func viewModelForSlider(indexPath: IndexPath) -> SliderCellViewModel {
        return SliderCellViewModel(shops: shops.value)
    }
    
    func viewModelForRecommend(indexPath: IndexPath) -> RecommendCellViewModel {
        return RecommendCellViewModel(recommends: recommends.value)
    }
    
    func viewModelForPopular(indexPath: IndexPath) -> PopularCellViewModel {
        return PopularCellViewModel(populars: populars.value)
    }

}
