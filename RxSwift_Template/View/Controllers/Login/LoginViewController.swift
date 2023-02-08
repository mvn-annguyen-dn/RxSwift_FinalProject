//
//  LoginViewController.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 03/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var errorUserNameLabel: UILabel!
    @IBOutlet private weak var errorPassWordLabel: UILabel!

    // MARK: - Properties
    private var bag: DisposeBag = DisposeBag()
    var viewModel: LoginViewModel = LoginViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        bindingViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - Private func
    private func bindingViewModel() {
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.userName)
            .disposed(by: bag)

        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passWord)
            .disposed(by: bag)

        viewModel.isValidate
            .drive(loginButton.rx.isEnabled)
            .disposed(by: bag)
        
        usernameTextField.rx.controlEvent(.editingDidBegin).subscribe { [weak self] _ in
            guard let this = self else { return }
            this.usernameTextField.becomeFirstResponder()
            this.viewModel.isValidUsername
                .drive(this.errorUserNameLabel.rx.text)
                .disposed(by: this.bag)
        }
        .disposed(by: bag)
        
        passwordTextField.rx.controlEvent(.editingDidBegin).subscribe { [weak self] _ in
            guard let this = self else { return }
            this.passwordTextField.becomeFirstResponder()
            this.viewModel.isValidPassword
                .drive(this.errorPassWordLabel.rx.text)
                .disposed(by: this.bag)
        }
        .disposed(by: bag)
    }
}
