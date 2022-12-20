//
//  RecommendCollectionViewCellViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 14/12/2022.
//

import Foundation
import RxCocoa
import RxSwift

final class RecommendCollectionViewCellViewModel {
    
    var music: Music
    
    init(music: Music) {
        self.music = music
    }
}
