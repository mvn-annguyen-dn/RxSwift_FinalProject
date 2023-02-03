//
//  Traits+Ext.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 03/02/2023.
//

import RxSwift
import RxCocoa
import Moya

public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    // This function will help us filters out responses that have the specified `status Code`.
    func filterStatusCodes() -> Single<Element> {
        flatMap { res in
            switch res.statusCode {
            case 200...299:
                return .just(res)
            case 400...499:
                throw ApiError.badRequest
            default:
                throw ApiError.unknown
            }
        }
    }
}
