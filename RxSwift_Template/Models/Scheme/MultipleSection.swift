//
//  OneSection.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 03/01/2023.
//

import RxSwift
import RxDataSources

enum TypeSection {
    case secret
    case attack
    case skill

    var type: String {
        switch self {
        case .secret:
            return "Secret"
        case .attack:
            return "Attack"
        case .skill:
            return "Skill"
        }
    }
}


struct FrontCard {
    var image: String
}

struct BackCard {
    var name: String
    var title: String
}

// OneCell
struct Card {
    var frontCard: FrontCard?
    var backCard: BackCard?
}

struct CardSectionModel {
    var header: TypeSection
    var items: [Card]
}

extension CardSectionModel: SectionModelType {
    typealias Item = Card
    init(original: CardSectionModel, items: [Item]) {
        self  = original
        self.items = items
    }
}

let cardSection: [CardSectionModel] = [.init(header: .secret, items: secretItems),
                                       .init(header: .attack, items: attackItems),
                                       .init(header: .skill, items: skillItems)]

let secretItems: [Card] =  [.init(frontCard: .init(image: "reptile-back-01"),
                                  backCard: .init(name: "Bone Sail", title: "ABCD")),
                            .init(frontCard: .init(image: "reptile-back-04"),
                                  backCard: .init(name: "Indian Star", title: "ABCD")),
                            .init(frontCard: .init(image: "reptile-back-06"),
                                  backCard: .init(name: "Croc", title: "ABCD"))]
let attackItems: [Card] = [.init(frontCard: .init(image: "reptile-back-02"),
                                 backCard: .init(name: "Tri Spikes", title: "ABCD"))]
let skillItems: [Card] = [.init(frontCard: .init(image: "reptile-back-03"),
                                backCard: .init(name: "Green Thorns", title: "ABCD")),
                          .init(frontCard: .init(image: "reptile-back-05"),
                                backCard: .init(name: "Red Ear", title: "ABCD"))]

// MultiCell
enum MyCard {
    case frontCard(FrontCard)
    case backCard(BackCard)
}

struct MyCardSectionModel {
    var header: TypeSection
    var items: [MyCard]
}

extension MyCardSectionModel: SectionModelType {
    init(original: MyCardSectionModel, items: [MyCard]) {
        self = original
        self.items = items
    }
}

let myCardSection: [MyCardSectionModel] = [.init(header: .secret, items: mySecretItems),
                                       .init(header: .attack, items: myAttackItems),
                                       .init(header: .skill, items: mySkillItems)]

let mySecretItems: [MyCard] =  [.frontCard(.init(image: "reptile-back-01")),
                                .backCard(.init(name: "Bone Sail", title: "ABCD")),
                                .frontCard(.init(image: "reptile-back-04")),
                                .backCard(.init(name: "Indian Star", title: "ABCD")),
                                .frontCard(.init(image: "reptile-back-06")),
                                .backCard(.init(name: "Croc", title: "ABCD"))]
let myAttackItems: [MyCard] = [.frontCard(.init(image: "reptile-back-02")),
                               .backCard(.init(name: "Tri Spikes", title: "ABCD"))]
let mySkillItems: [MyCard] = [.frontCard(.init(image: "reptile-back-03")),
                              .backCard(.init(name: "Green Thorns", title: "ABCD")),
                              .frontCard(.init(image: "reptile-back-05")),
                              .backCard(.init(name: "Red Ear", title: "ABCD"))]
