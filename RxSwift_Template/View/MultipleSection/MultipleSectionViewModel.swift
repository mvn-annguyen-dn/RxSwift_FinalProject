//
//  MultipleSectionViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 03/01/2023.
//

import RxCocoa
import RxSwift

final class MultipleSectionViewModel {
    let dataRelay: BehaviorRelay<[MyCardSectionModel]> = .init(value: [])

    func setUpData() {
        dataRelay.accept(myCardSection)
    }

    func viewModelForItem(at element: FrontCard) -> ReptipleCellViewModel {
        return ReptipleCellViewModel(card: element)
    }

    func viewModelForItem2(at element: BackCard) -> TitleCellViewModel {
        return TitleCellViewModel(card: element)
    }

    func viewHeaderForItem(at indexPath: IndexPath) -> HeaderCellViewModel {
        return HeaderCellViewModel(title: dataRelay.value[indexPath.section].header)
    }
}
