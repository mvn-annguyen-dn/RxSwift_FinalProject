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
    private(set) var userName: BehaviorRelay<String> = .init(value: "")
    private(set) var passWord: BehaviorRelay<String> = .init(value: "")
    private(set) var isValidate: Driver<Bool> = .just(false)

    let errorStatus: PublishSubject<ApiError> = .init()

    var isValidUsername: Driver<String?> {
        return    userName.map { username in
            username.count < 6 && username.count > 0 ? Define.isValidUserName : nil
        }
        .asDriver(onErrorJustReturn: nil)
    }
    
    var isValidPassword: Driver<String?> {
        return passWord.map {
            password in
            password.count < 6 && password.count > 0 ? Define.isValidPassWord : nil
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

// MARK: Handle and Call APi
extension LoginViewModel {
    // Send Request
    func requestLoginAPI() -> Single<TokenRespone> {
        return ApiNetWorkManager.shared.request(TokenRespone.self, .target(LoginTarget.login(userName: userName.value, passWord: passWord.value)))
    }

    // Handle Response
    func handleLoginResponse() {
        requestLoginAPI()
            .subscribe(onSuccess: { respose in
                Session.shared.token = respose.data?.accessToken ?? ""
            }, onFailure: { error in
                self.errorStatus.onNext(error as? ApiError ?? .unknown)
            })
            .disposed(by: bag)
    }
}

extension LoginViewModel {
    struct Define {
        static var isValidUserName: String = "Invild username"
        static var isValidPassWord: String = "Invild password"
    }
}
