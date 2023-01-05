//
//  CaseOneViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 04/01/2023.
//

import RxCocoa
import RxSwift
import RxDataSources

final class CaseOneViewModel {
    
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
                self.sectionRelay.accept([AnimalSection(header: "first Section", items: self.musicBehaviorRelay.value)])
            case .failure(let error):
                self.errorMusicBehaviorRelay.accept(error.localizedDescription)
            }
        }
        .disposed(by: bag)
    }
    
    func getDataFirstCell(indexPath: IndexPath) -> CaseOneCellViewModel {
        return CaseOneCellViewModel(music: musicBehaviorRelay.value[indexPath.row])
    }
}
