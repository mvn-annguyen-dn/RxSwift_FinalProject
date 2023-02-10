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

    private var bag: DisposeBag = DisposeBag()
    private(set) var userName: PublishSubject<String> = .init()
    private(set) var passWord: PublishSubject<String> = .init()
    
    let errorStatus: PublishSubject<ApiError> = .init()
        
    var isValidate: Driver<Bool> {
        return Observable.combineLatest(isValidUsername.asObservable(), isValidPassword.asObservable(), isEmpty)
            .map { $0 == nil && $1 == nil && $2 == false }
            .distinctUntilChanged()
            .debug()
            .asDriver(onErrorJustReturn: false)
    }
    
    var isValidUsername: Driver<String?> {
        return userName.map { !$0.validateUsername() ? Define.isValidUserName : nil }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var isValidPassword: Driver<String?> {
        return passWord.map { $0.count < 6 ? Define.isValidPassWord : nil }
            .asDriver(onErrorJustReturn: nil)
    }
    
    var isEmpty: Observable<Bool> {
        return Observable.combineLatest(userName, passWord)
            .map { username, password in
                username.isEmpty || password.isEmpty
            }
    }
}

// MARK: Handle and Call APi
extension LoginViewModel {
    // Send Request
    func requestLoginAPI() -> Single<TokenRespone> {
        return ApiNetWorkManager.shared.request(TokenRespone.self, .target(LoginTarget.login(userName: "", passWord: "")))
    }

    // Handle Response
    func handleLoginResponse() {
        requestLoginAPI()
            .subscribe(onSuccess: { respose in
                Session.shared.token = respose.data?.accessToken ?? ""
                AppDelegate.shared.setRoot(rootType: .home)
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
