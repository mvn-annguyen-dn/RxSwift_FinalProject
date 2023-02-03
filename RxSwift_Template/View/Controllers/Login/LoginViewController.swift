//
//  LoginViewController.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 03/02/2023.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var errorUserNameLabel: UILabel!
    @IBOutlet private weak var errorPassWordLabel: UILabel!

    // MARK: - Properties
    var viewModel: LoginViewModel = LoginViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }

    // MARK: - Private methods
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
        usernameTextField.layer.rx
            .cornerRadius
            .onNext(Define.cornerRadius)
        usernameTextField.layer.rx
            .borderWidth
            .onNext(Define.borderWidth)
        usernameTextField.layer.rx
            .borderColor
            .onNext(Define.borderColor)
        passwordTextField.layer.rx
            .cornerRadius
            .onNext(Define.cornerRadius)
        passwordTextField.layer.rx
            .borderWidth
            .onNext(Define.borderWidth)
        passwordTextField.layer.rx
            .borderColor
            .onNext(Define.borderColor)
    }

    private func configButton() {
        loginButton.layer.rx
            .cornerRadius
            .onNext(Define.cornerRadius)
    }
}

// MARK: - Define
extension LoginViewController {
    private struct Define {
        static var cornerRadius: CGFloat = 5.0
        static var borderWidth: CGFloat = 1.0
        static var borderColor: CGColor = UIColor.systemGreen.cgColor
        static var gradientColor: [CGColor] = [
            CGColor(_colorLiteralRed: 0.69, green: 0.95, blue: 0.95, alpha: 1.00),
            CGColor(_colorLiteralRed: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        ]
    }
}
