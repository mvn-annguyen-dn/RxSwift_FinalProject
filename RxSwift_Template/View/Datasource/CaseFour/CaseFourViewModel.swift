//
//  CaseFourViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 04/01/2023.
//

import RxSwift
import RxCocoa
import RxDataSources

final class CaseFourViewModel {
    
    let bag: DisposeBag = DisposeBag()
    var musicBehaviorRelay: BehaviorRelay<[Music]> = .init(value: [])
    var errorMusicBehaviorRelay: BehaviorRelay<String?> = .init(value: nil)
    
    // multiple sections
    var sectionModels: BehaviorSubject<[HomeSectionModel]> = BehaviorSubject(value: [])
    var sectionModelsDriver: Driver<[HomeSectionModel]> {
        return sectionModels.asDriver(onErrorJustReturn: [])
    }
    
    func getApiMusic() -> Single<FeedResults> {
        return ApiManager.shared.loadAPI(method: .get)
    }
    
    func loadApiMusic() {
        getApiMusic().subscribe { result in
            switch result {
            case .success(let value):
                self.musicBehaviorRelay.accept(value.results ?? [])
                let sections: [HomeSectionModel] = [
                    .informationSectionOne(title: "Section 1", items: [
                        .itemOne(musics: self.musicBehaviorRelay.value.randomElement() ?? Music()),
                        .itemOne(musics: self.musicBehaviorRelay.value.randomElement() ?? Music()),
                        .itemOne(musics: self.musicBehaviorRelay.value.randomElement() ?? Music())
                    ]),
                    .informationSectionTwo(title: "Section 2", items: [
                        .itemTwo(title: "Item section 2", musics: self.musicBehaviorRelay.value.randomElement() ?? Music()),
                        .itemOne(musics: self.musicBehaviorRelay.value.randomElement() ?? Music()),
                        .itemOne(musics: self.musicBehaviorRelay.value.randomElement() ?? Music())
                    ])
                ]
                self.sectionModels.onNext(sections)
            case .failure(let error):
                self.errorMusicBehaviorRelay.accept(error.localizedDescription)
            }
        }
        .disposed(by: bag)
    }
    
    func getDataFirstCell(music: Music, indexPath: IndexPath) -> CaseOneCellViewModel {
        return CaseOneCellViewModel(music: music)
    }
    
    func getDataSecondCell(music: Music, indexPath: IndexPath, title: String) -> FirstCellViewModel {
        return FirstCellViewModel(music: music, title: title)
    }
}