//
//  CartTableViewCell.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 20/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

@objc
protocol CartTableViewCellDelegate {
    @objc optional func increase(_ cell: CartTableViewCell)
    @objc optional func decrease(_ cell: CartTableViewCell)
    @objc optional func inputQuantity(_ cell: CartTableViewCell, quantity: String)
}

final class CartTableViewCellDelegateProxy: DelegateProxy<CartTableViewCell, CartTableViewCellDelegate>, DelegateProxyType, CartTableViewCellDelegate {
    
    weak public private(set) var cartCell: CartTableViewCell?
    
    public init(cartCell: ParentObject) {
        self.cartCell = cartCell
        super.init(parentObject: cartCell, delegateProxy: CartTableViewCellDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { CartTableViewCellDelegateProxy(cartCell: $0) }
    }
    
    static func currentDelegate(for object: CartTableViewCell) -> CartTableViewCellDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: CartTableViewCellDelegate?, to object: CartTableViewCell) {
        object.delegate = delegate
    }
}

final class CartTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var quantityTextField: UITextField!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var minusButton: UIButton!
    
    // MARK: - Properties
    var bag: DisposeBag = DisposeBag()
    var viewModel: CartCellViewModel? {
        didSet {
            updateCell()
        }
    }
    
    weak var delegate: CartTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    // MARK: - Private func
    private func configUI() {
        productImageView.layer.rx.cornerRadius.onNext(Define.cornerRadius)
    }
    
    private func updateCell() {
        guard let viewModel = viewModel else { return }
        let cart = viewModel.cart
            .compactMap { $0 }
        cart.map(\.productName)
            .bind(to: nameLabel.rx.text)
            .disposed(by: bag)
        
        cart.map(\.price)
            .subscribe(onNext: { value in
                let price = "$ \(value ?? 0)"
                self.priceLabel.rx.text.onNext(price)
            })
            .disposed(by: bag)
        
        cart.map(\.quantity)
            .subscribe(onNext: { value in
                let quantity = "\(value ?? 0)"
                self.quantityTextField.rx.text.onNext(quantity)
            })
            .disposed(by: bag)
        
        cart.map(\.productImage)
            .flatMap({DownloadImage.shared.dowloadImageWithRxSwift(url: $0 ?? "")})
            .bind(to: productImageView.rx.image)
            .disposed(by: bag)
        
        plusButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                guard let this = self else { return }
                this.delegate?.increase?(this)
            })
            .disposed(by: bag)
        
        minusButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                guard let this = self else { return }
                this.delegate?.decrease?(this)
            })
            .disposed(by: bag)
        
        quantityTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .do(onNext: { _ in
                self.quantityTextField.becomeFirstResponder()
            })
            .map { self.quantityTextField.text ?? "" }
            .subscribe(onNext: { value in
                self.delegate?.inputQuantity?(self, quantity: value)
            })
            .disposed(by: bag)
    }
}

extension CartTableViewCell {
    private struct Define {
        static var cornerRadius: CGFloat = 10
    }
}
