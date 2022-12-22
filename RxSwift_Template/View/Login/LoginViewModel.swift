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
    let userName: BehaviorRelay<String> = BehaviorRelay(value: "")
    let passWord: BehaviorRelay<String> = BehaviorRelay(value: "")
    var loginTap: PublishSubject<Void> = PublishSubject<Void>()
    
    var isValidUsername: Driver<String?> {
        return    userName.asObservable().map { username in
            username.count < 6 ? Config.isValidUserName : nil
        }
        .asDriver(onErrorJustReturn: nil)
    }
    
    var isValidPassword: Driver<String?> {
        return passWord.asObservable().map {
            password in
            password.count < 6 ? Config.isValidPassWord : nil
        }
        .asDriver(onErrorJustReturn: nil)
    }
    
    var isValid: Driver<Bool> {
        return Observable.combineLatest(isValidUsername.asObservable(), isValidPassword.asObservable())
            .map { $0 == nil && $1 == nil }
            .asDriver(onErrorJustReturn: false)
    }
    
    var loginDone: Driver<Music?> = .just(nil)
    
    init() {
        let usernameAndPasswordObservable: Observable<(String, String)> = Observable.combineLatest(userName.asObservable(), passWord.asObservable()) {($0, $1)}
        let request = loginTap
            .withLatestFrom(usernameAndPasswordObservable)
            .flatMap { self.getApiMusic(userName: $0.0, password: $0.1) }
        loginDone = request
            .compactMap {$0.results?.first}
            .debug()
            .asDriver(onErrorJustReturn: nil)
    }
    
    func getApiMusic(userName: String, password: String) -> Single<FeedResults> {
        return ApiManager.shared.loadAPI(method: .get)
    }
}

extension LoginViewModel {
    struct Config {
        static var isValidUserName: String = "Invild username"
        static var isValidPassWord: String = "Invild password"
    }
}
