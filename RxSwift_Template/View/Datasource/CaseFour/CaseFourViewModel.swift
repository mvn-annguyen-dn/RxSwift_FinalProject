//
//  CaseFourViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 04/01/2023.
//

import RxSwift
import RxCocoa

final class CaseFourViewModel {
    
    let bag: DisposeBag = DisposeBag()
    var musicBehaviorRelay: BehaviorRelay<[Music]> = .init(value: [])
    var errorMusicBehaviorRelay: BehaviorRelay<String?> = .init(value: nil)
    let sectionRelay = BehaviorRelay<[AnimalSection]>.init(value: [])
    
    func getApiMusic() -> Single<FeedResults> {
        return ApiManager.shared.loadAPI(method: .get)
    }
    
    func loadApiMusic() {
        getApiMusic().subscribe { result in
            switch result {
            case .success(let value):
                self.musicBehaviorRelay.accept(value.results ?? [])
                self.sectionRelay.accept([AnimalSection(header: "First Section", items: self.musicBehaviorRelay.value), AnimalSection(header: "Second Section", items: self.musicBehaviorRelay.value)])
            case .failure(let error):
                self.errorMusicBehaviorRelay.accept(error.localizedDescription)
            }
        }
        .disposed(by: bag)
    }
    
    func getDataFirstCell(indexPath: IndexPath) -> FirstCellViewModel {
        return FirstCellViewModel(music: musicBehaviorRelay.value[indexPath.row])
    }
    
    func getDataSecondCell(indexPath: IndexPath) -> CaseOneCellViewModel {
        return CaseOneCellViewModel(music: musicBehaviorRelay.value[indexPath.row])
    }
}
