//
//  LoginViewController.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 06/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var passWordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var errorLabel: UILabel!
    
    var viewModel: LoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindingViewModel()
    }
    
    // MARK: - Private func
    private func bindingViewModel() {
        userNameTextField.rx.text.orEmpty
            .bind(to: viewModel.userName)
            .disposed(by: viewModel.bag)
        
        passWordTextField.rx.text.orEmpty
            .bind(to: viewModel.passWord)
            .disposed(by: viewModel.bag)

        viewModel.isValidUsername.drive(errorLabel.rx.text)
        .disposed(by: viewModel.bag)

        viewModel.isValidPassword.drive(errorLabel.rx.text)
        .disposed(by: viewModel.bag)

        viewModel.isValid
            .drive(loginButton.rx.enableAndChangeColorButton)
            .disposed(by: viewModel.bag)
        
        loginButton.rx.tap
            .bind(to: viewModel.loginTap)
            .disposed(by: viewModel.bag)

        viewModel.loginDone.subscribe(onNext: { _ in
            AppDelegate.shared.setRoot(root: .tabbar)
        })
        .disposed(by: viewModel.bag)
    }
}

extension Reactive where Base: UIButton {
    var enableAndChangeColorButton: Binder<Bool> {
        return Binder(base.self) { btn, isEnabled in
            btn.backgroundColor = isEnabled ? .red : UIColor.gray
        }
    }
}
