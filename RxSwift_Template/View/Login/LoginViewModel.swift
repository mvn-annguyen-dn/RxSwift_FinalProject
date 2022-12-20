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

    let userName: BehaviorRelay<String> = BehaviorRelay(value: "")
    let passWord: BehaviorRelay<String> = BehaviorRelay(value: "")
    var loginTap: PublishSubject<Void> = PublishSubject<Void>()
    
    var isValidUsername: Driver<Bool> {
        return    userName.asObservable().map { username in
            username.count >= 6
        }.asDriver(onErrorJustReturn: false)
    }
    
    var isValidPassword: Driver<Bool> {
        return passWord.asObservable().map {
            password in
            password.count >= 6
        }.asDriver(onErrorJustReturn: false)
    }

    var isValid: Driver<Bool> {
        return Observable.combineLatest(isValidUsername.asObservable(), isValidPassword.asObservable()) {$0 && $1}.asDriver(onErrorJustReturn: false)
    }

    var loginDone: Driver<Music?> = .just(nil)
    let bag: DisposeBag = DisposeBag()

    init() {
        let usernameAndPasswordObservable: Observable<(String, String)> = Observable.combineLatest(userName.asObservable(), passWord.asObservable()) {($0, $1)}
        let request = loginTap.asObservable()
            .withLatestFrom(usernameAndPasswordObservable)
            .flatMap { self.getApiMusic(userName: $0.0, password: $0.1) }
        loginDone = request.asObservable()
            .compactMap {$0.results?.first}
            .debug()
            .asDriver(onErrorJustReturn: nil)
    }

    func getApiMusic(userName: String, password: String) -> Single<FeedResults> {
        return ApiManager.shared.loadAPI(method: .get)
    }
}
