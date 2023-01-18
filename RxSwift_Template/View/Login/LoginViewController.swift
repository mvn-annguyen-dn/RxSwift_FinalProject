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
    @IBOutlet private weak var errorUserNameLabel: UILabel!
    @IBOutlet private weak var errorPassWordLabel: UILabel!
    
    var viewModel: LoginViewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindingViewModel()
    }

    private func bindingViewModel() {
        userNameTextField.rx.text.orEmpty
            .bind(to: viewModel.userName)
            .disposed(by: viewModel.bag)
        
        passWordTextField.rx.text.orEmpty
            .bind(to: viewModel.passWord)
            .disposed(by: viewModel.bag)
        
        viewModel.isValidUsername.drive(errorUserNameLabel.rx.text)
            .disposed(by: viewModel.bag)

        viewModel.isValidPassword.drive(errorPassWordLabel.rx.text)
            .disposed(by: viewModel.bag)
        
        viewModel.isValid
            .drive(loginButton.rx.isEnabled)
            .disposed(by: viewModel.bag)
        
        loginButton.rx.tap
            .bind(to: viewModel.loginTap)
            .disposed(by: viewModel.bag)
        
        viewModel.loginDone.subscribe { _ in
            AppDelegate.shared.setRoot(root: .tabbar)
        }
        .disposed(by: viewModel.bag)
    }
}
