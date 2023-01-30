//
//  OneSection.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 03/01/2023.
//

import Foundation

struct Name {
    var name: String
}

struct Image {
    var image: String
}

enum MultipleCell {
    case name(Name)
    case image(Image)
}

// Data OneCell
let names: [Name] = [.init(name: "Zulfiqar Victor"), .init(name: "Live DeMarcus"),
                     .init(name: "Sergo Yohanes"), .init(name: "Aleyna Ivo"),
                     .init(name: "Junia Spartacus"), .init(name: "Trygve Kord"),
                     .init(name: "Sander Alby"), .init(name: "Jehohanan Meir"),
                     .init(name: "Aubin Túpac"), .init(name: "Helena Upendo")]

// Data MultipleCell
let multiple: [MultipleCell] = [.name(.init(name: "Zulfiqar Victor")), .image(.init(image: "image1")),
                                .name(.init(name: "Aleyna Ivo")), .image(.init(image: "image2")),
                                .name(.init(name: "Trygve Kord")), .image(.init(image: "image3")),
                                .name(.init(name: "Zulfiqar Victor")), .image(.init(image: "image1")),
                                .name(.init(name: "Aleyna Ivo")), .image(.init(image: "image2")),
                                .name(.init(name: "Trygve Kord")), .image(.init(image: "image3")),
                                .name(.init(name: "Zulfiqar Victor")), .image(.init(image: "image1")),
                                .name(.init(name: "Aleyna Ivo")), .image(.init(image: "image2")),
                                .name(.init(name: "Trygve Kord")), .image(.init(image: "image3"))]


