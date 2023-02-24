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
            .subscribe(onNext: { _ in
                #warning("Handle Later")
            })
            .disposed(by: disposeBag)
    }
}

// MARK: getApis
extension ProfileViewController {
    

}
