//
//  LoginViewController.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 03/02/2023.
//

import UIKit
import RxSwift

final class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var errorUserNameLabel: UILabel!
    @IBOutlet private weak var errorPassWordLabel: UILabel!

    // MARK: - Properties
    var bag: DisposeBag = DisposeBag()
    var viewModel: LoginViewModel = LoginViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        bindingViewModel()
    }
    
    // MARK: - Private func
    private func bindingViewModel() {
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.userName)
            .disposed(by: viewModel.bag)

        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passWord)
            .disposed(by: viewModel.bag)

        viewModel.isValidUsername.drive(errorUserNameLabel.rx.text)
            .disposed(by: viewModel.bag)

        viewModel.isValidPassword.drive(errorPassWordLabel.rx.text)
            .disposed(by: viewModel.bag)

        viewModel.isValidate
            .drive(loginButton.rx.isEnabled)
            .disposed(by: viewModel.bag)
    }
}
