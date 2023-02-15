//
//  ProfileViewController.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 14/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var firstCharaterLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var accountInfomationButton: UIButton!
    @IBOutlet private weak var orderButton: UIButton!
    @IBOutlet private weak var settingButton: UIButton!
    @IBOutlet private weak var logOutButton: UIButton!
    
    // MARK: - Properties
    var viewModel: ProfileViewModel?
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigation()
        configUI()
        configGesture()
        updateUI()
        alerStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.rx.isHidden.onNext(false)
    }
    
    // MARK: - Private methods
    private func configNavigation() {
        setTitleNavigation(type: .profile)
    }
    
    private func configUI() {
        firstCharaterLabel.clipsToBounds = true
        firstCharaterLabel.layer.cornerRadius = firstCharaterLabel.frame.size.width / 2
    }

    private func configGesture() {
        logOutButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let this = self,
                      let viewModel = this.viewModel else { return }
                viewModel.logOutUser()
            })
            .disposed(by: disposeBag)
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        viewModel.getApiUser()
        let user = viewModel.userInfo.compactMap { $0 }
        user.map(\.userName)
            .map { $0?.uppercased().first?.description }
            .bind(to: firstCharaterLabel.rx.text)
            .disposed(by: disposeBag)
        user.map(\.userName)
            .bind(to: usernameLabel.rx.text)
            .disposed(by: disposeBag)
        user.map(\.email)
            .bind(to: emailLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func alerStatus() {
        guard let viewModel = viewModel else { return }
        viewModel.errorState
            .subscribe(onNext: { [weak self] error in
                guard let this = self,
                      let error = error else { return }
                this.normalAlert(message: error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}
