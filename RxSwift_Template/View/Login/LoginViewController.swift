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

        viewModel.isValidUsername.drive { isValid in
            self.errorLabel.text = isValid
        }
        .disposed(by: viewModel.bag)

        viewModel.isValidPassword.drive { isValid in
            self.errorLabel.text = isValid
        }
        .disposed(by: viewModel.bag)

        viewModel.isValid
            .drive(loginButton.rx.enableButton)
            .disposed(by: viewModel.bag)
        
        loginButton.rx.tap
            .bind(to: viewModel.loginTap)
            .disposed(by: viewModel.bag)
        
        viewModel.loginDone
            .asObservable()
            .subscribe(onNext: { music in
                if let name = music?.name, !name.isEmpty {
                    AppDelegate.shared.setRoot(root: .tabbar)
                }
            })
            .disposed(by: viewModel.bag)
    }
}

extension Reactive where Base: UIButton {
    var enableButton: Binder<Bool> {
        return Binder(base.self) { btn, isEnabled in
            btn.backgroundColor = isEnabled ? .red : UIColor.gray
        }
    }
}
