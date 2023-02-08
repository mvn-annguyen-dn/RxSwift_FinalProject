//
//  String+Ext.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 03/02/2023.
//

import Foundation

extension String {
    
    func validateUsername() -> Bool {
        let usernameRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[com]{3}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", usernameRegex)
        return predicate.evaluate(with: self)
    }
}
