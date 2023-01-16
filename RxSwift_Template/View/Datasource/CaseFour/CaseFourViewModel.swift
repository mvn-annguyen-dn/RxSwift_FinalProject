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
    var errorMusicBehaviorRelay: PublishRelay<Error> = .init()
    
    // multiple sections
    var sectionModels: BehaviorRelay<[HomeSectionModel]> = .init(value: [])
    
    func getApiMusic() -> Single<FeedResults> {
        return ApiManager.shared.loadAPI(method: .get)
    }
    
    func loadApiWithMoya() {
        ApiNetWorkManager.shared.request(FeedResults.self, .getMusic).subscribe { event in
            switch event {
            case .success(let value):
                self.musicBehaviorRelay.accept(value.results ?? [])
                let sections: [HomeSectionModel] = [
                    .informationSectionOne(title: "Section 1", items: [
                        .itemOne(music: self.musicBehaviorRelay.value[3]),
                        .itemOne(music: self.musicBehaviorRelay.value.randomElement() ?? Music()),
                        .itemOne(music: self.musicBehaviorRelay.value.randomElement() ?? Music())
                    ]),
                    .informationSectionTwo(title: "Section 2", items: [
                        .itemTwo(title: "Item section 2", music: self.musicBehaviorRelay.value.randomElement() ?? Music()),
                        .itemOne(music: self.musicBehaviorRelay.value.randomElement() ?? Music()),
                        .itemOne(music: self.musicBehaviorRelay.value.randomElement() ?? Music())
                    ])
                ]
                self.sectionModels.accept(sections)
            case .failure(let error):
                self.errorMusicBehaviorRelay.accept(error)
            }
        }
        .disposed(by: bag)
    }
    
    func getDataFirstCell(music: Music) -> CaseOneCellViewModel {
        return CaseOneCellViewModel(music: music)
    }
    
    func getDataSecondCell(music: Music, title: String) -> FirstCellViewModel {
        return FirstCellViewModel(music: music, title: title)
    }
}
