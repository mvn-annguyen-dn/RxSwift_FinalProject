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

    // MARK: Outlets
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var passWordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var errorUserNameLabel: UILabel!
    @IBOutlet private weak var errorPassWordLabel: UILabel!
    
    // MARK: Properties
    var viewModel: LoginViewModel = LoginViewModel()

    // MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        bindingViewModel()
    }

    // MARK: Private methods
    private func configUI() {
        configGradient()
        configTextField()
        configButton()
    }
    
    private func configGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero,
                                     size: CGSize(width: self.view.frame.size.width + 20,
                                                  height: self.view.frame.size.height))
        gradientLayer.rx.colors.onNext(Define.gradientColor)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func configTextField() {
        userNameTextField.layer.rx
            .cornerRadius
            .onNext(Define.cornerRadius)
        userNameTextField.layer.rx
            .borderWidth
            .onNext(Define.borderWidth)
        userNameTextField.layer.rx
            .borderColor
            .onNext(Define.borderColor)
        passWordTextField.layer.rx
            .cornerRadius
            .onNext(Define.cornerRadius)
        passWordTextField.layer.rx
            .borderWidth
            .onNext(Define.borderWidth)
        passWordTextField.layer.rx
            .borderColor
            .onNext(Define.borderColor)
    }
    
    private func configButton() {
        loginButton.layer.rx
            .cornerRadius
            .onNext(Define.cornerRadius)
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

// MARK: Define
extension LoginViewController {
    private struct Define {
        static var title: String = "Login"
        static var cornerRadius: CGFloat = 5.0
        static var borderWidth: CGFloat = 1.0
        static var borderColor: CGColor = UIColor.systemGreen.cgColor
        static var gradientColor: [CGColor] = [
            CGColor(_colorLiteralRed: 0.69, green: 0.95, blue: 0.95, alpha: 1.00),
            CGColor(_colorLiteralRed: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        ]
    }
}
