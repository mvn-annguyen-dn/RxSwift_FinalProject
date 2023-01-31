//
//  LoginViewModel.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 07/12/2022.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

final class LoginViewModel {
    
    let bag: DisposeBag = DisposeBag()
    private(set) var userName: BehaviorRelay<String> = BehaviorRelay(value: "")
    private(set) var passWord: BehaviorRelay<String> = BehaviorRelay(value: "")
    private(set) var loginTap: PublishSubject<Void> = PublishSubject<Void>()
    private(set) var loginDone: Observable<User?> = .just(nil)
    
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
    
    var isValid: Driver<Bool> {
        return Observable.combineLatest(isValidUsername.asObservable(), isValidPassword.asObservable(), isEmpty)
            .map { $0 == nil && $1 == nil && $2 == false }
            .asDriver(onErrorJustReturn: false)
    }
    
    init() {
        binding()
    }
    
    func binding() {
        let usernameAndPasswordObservable: Observable<(String, String)> = Observable.combineLatest(userName, passWord) {($0, $1)}
        let request = loginTap
            .withLatestFrom(usernameAndPasswordObservable)
            .flatMap { username, password in
                self.getApiUser(userName: username, passWord: password)
            }
        
        loginDone = request.compactMap { $0 }
            .debug()
    }
    
    func getApiUser(userName: String, passWord: String) -> Single<User> {
        return ApiNetWorkManager.shared
            .request(User.self, .target(LoginTarget.login(userName: userName, password: passWord)))
    }
}

extension LoginViewModel {
    struct Config {
        static var isValidUserName: String = "Invild username"
        static var isValidPassWord: String = "Invild password"
    }
}
