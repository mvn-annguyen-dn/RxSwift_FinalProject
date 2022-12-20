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
    
    let bag: DisposeBag = DisposeBag()
    var viewModel: LoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindingViewModel()
    }
    
    // MARK: - Private func
    private func bindingViewModel() {
        userNameTextField.delegate = self
        passWordTextField.delegate = self
        
        userNameTextField.rx.text.orEmpty
            .bind(to: viewModel.userName)
            .disposed(by: bag)
        
        passWordTextField.rx.text.orEmpty
            .bind(to: viewModel.passWord)
            .disposed(by: bag)
        
        viewModel.isValid
            .drive(loginButton.rx.enableButton)
            .disposed(by: bag)
        
        loginButton.rx.tap
            .bind(onNext: {
                self.viewModel.loginTap.onNext(Void())
            }).disposed(by: bag)
        
        viewModel.loginDone
            .asObservable()
            .subscribe(onNext: { music in
                if let name = music?.name, !name.isEmpty {
                    AppDelegate.shared.setRoot(root: .tabbar)
                }
            })
            .disposed(by: bag)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case userNameTextField:
            viewModel.isValidUsername.drive { isValid in
                self.errorLabel.text = !isValid ? Config.isValidUserName : nil
            }.disposed(by: bag)
        case passWordTextField:
            viewModel.isValidPassword.drive { isValid in
                self.errorLabel.text = !isValid ? Config.isValidPassWord : nil
            }.disposed(by: bag)
        default: break
        }
    }
}

extension Reactive where Base: UIButton {
    var enableButton: Binder<Bool> {
        return Binder(base.self) { btn, isEnabled in
            btn.backgroundColor = isEnabled ? .red : UIColor.gray
        }
    }
}

extension LoginViewController {
    struct Config {
        static var isValidUserName: String = "Invild username"
        static var isValidPassWord: String = "Invild password"
    }
}
