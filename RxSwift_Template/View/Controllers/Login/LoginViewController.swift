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
        usernameTextField.rx.controlEvent(.editingDidBegin).subscribe { [weak self] _ in
            guard let this = self else { return }
            this.usernameTextField.becomeFirstResponder()
            this.usernameTextField.rx.text.distinctUntilChanged()
                .map { $0 ?? "" }
                .bind(to: this.viewModel.userName)
                .disposed(by: this.bag)
        }
        .disposed(by: bag)
        
        passwordTextField.rx.controlEvent(.editingDidBegin).subscribe { [weak self] _ in
            guard let this = self else { return }
            this.passwordTextField.becomeFirstResponder()
            this.passwordTextField.rx.text.distinctUntilChanged()
                .map { $0 ?? "" }
                .bind(to: this.viewModel.passWord)
                .disposed(by: this.bag)
        }
        .disposed(by: bag)
        
        viewModel.isValidUsername
            .drive(errorUserNameLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.isValidPassword
            .drive(errorPassWordLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.isValidate
            .startWith(false)
            .drive(loginButton.rx.isEnabled)
            .disposed(by: bag)
    }
}
