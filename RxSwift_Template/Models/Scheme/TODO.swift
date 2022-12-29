//
//  TODO.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 23/12/2022.
//

import Foundation
import RxDataSources

struct TODO {
    let id = UUID()
    let title: String
}

var dummyData: [TODO] = [.init(title: "ABC"), .init(title: "BCD"), .init(title: "DEF")]
