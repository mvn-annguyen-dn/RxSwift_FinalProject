//
//  LoginViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 03/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
    
    var bag: DisposeBag = DisposeBag()
    private(set) var userName: BehaviorSubject<String> = .init(value: "")
    private(set) var passWord: BehaviorSubject<String> = .init(value: "")
    private(set) var isValidate: Driver<Bool> = .just(false)

    var isValidUsername: Driver<String?> {
        return    userName.map { username in
            username.count < 6 && username.count > 0 ? Config.isValidUserName : nil
        }
        .asDriver(onErrorJustReturn: nil)
    }
    
    var isValidPassword: Driver<String?> {
        return passWord.map {
            password in
            password.count < 6 && password.count > 0 ? Config.isValidPassWord : nil
        }
        .asDriver(onErrorJustReturn: nil)
    }
    
    var isEmpty: Observable<Bool> {
        return Observable.combineLatest(userName, passWord)
            .map { username, password in
                username.isEmpty || password.isEmpty
            }
    }
    
    init() {
        binding()
    }
    
    func binding() {
        isValidate = Observable.combineLatest(isValidUsername.asObservable(), isValidPassword.asObservable(), isEmpty)
            .map { $0 == nil && $1 == nil && $2 == false }
            .asDriver(onErrorJustReturn: false)
    }
}

extension LoginViewModel {
    struct Config {
        static var isValidUserName: String = "Invild username"
        static var isValidPassWord: String = "Invild password"
    }
}
