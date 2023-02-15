//
//  ProfileViewModel.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 14/02/2023.
//

import RxSwift
import RxCocoa

final class ProfileViewModel {
    private(set) var userInfo: PublishRelay<User?> = .init()

    private let bagModel: DisposeBag = DisposeBag()

    let errorState: PublishRelay<ApiError?> = .init()

    func getApiUser() {
        ApiNetWorkManager.shared.request(UserResponse.self, .target(MainTarget.user))
            .subscribe(onSuccess: { [weak self] response in
                guard let this = self else { return }
                this.userInfo.accept(response.data)
            }, onFailure: { [weak self] error in
                guard let this = self else { return }
                this.errorState.accept(error as? ApiError ?? .unknown)
            })
            .disposed(by: bagModel)
    }

    func logOutUser() {
        ApiNetWorkManager.shared.request(MessageResponse.self, .target(LoginTarget.logout))
            .subscribe(onSuccess: { _ in
                Session.shared.token = ""
                AppDelegate.shared.setRoot(rootType: .login)
            },onFailure: { error in
                self.errorState.accept(error as? ApiError ?? .unknown)
            })
            .disposed(by: bagModel)
    }
}
