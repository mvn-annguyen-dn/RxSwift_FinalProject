//
//  FirstCellViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 04/01/2023.
//

import RxSwift
import RxCocoa

final class FirstCellViewModel {
    
    let bag: DisposeBag = DisposeBag()
    var musicBehaviorRelay: BehaviorRelay<Music?> = .init(value: nil)
    var title: String?

    init(music: Music, title: String?) {
        musicBehaviorRelay.accept(music)
        self.title = title
    }
}
