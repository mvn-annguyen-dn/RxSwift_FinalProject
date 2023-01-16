//
//  CaseOneCellViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 04/01/2023.
//

import RxSwift
import RxCocoa

final class CaseOneCellViewModel {
    
    var bag: DisposeBag = DisposeBag()
    var musicBehaviorRelay: BehaviorRelay<Music?> = .init(value: nil)

    init(music: Music) {
        musicBehaviorRelay.accept(music)
    }

}
