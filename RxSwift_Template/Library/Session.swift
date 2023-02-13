//
//  Session.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 06/02/2023.
//

import Foundation

class Session {
    static let shared: Session = {
        let shared: Session = Session()
        return shared
    }()
    
    var token: String {
        get {
            return ud.string(forKey: KeysUserDefault.Keys.token.rawValue) ?? ""
        }
        set {
            return ud.set(newValue, forKey: KeysUserDefault.Keys.token.rawValue)
        }
    }
}

struct KeysUserDefault {
    enum Keys: String, CaseIterable {
        case token = "token"
    }
}
