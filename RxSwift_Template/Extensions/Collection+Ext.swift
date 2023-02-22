//
//  Collection+Ext.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 03/02/2023.
//

import Foundation

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
