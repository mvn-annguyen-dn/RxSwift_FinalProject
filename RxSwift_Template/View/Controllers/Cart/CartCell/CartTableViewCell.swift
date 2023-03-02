//
//  CartTableViewCell.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 20/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class CartTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var quantityTextField: UITextField!
    
    // MARK: - Properties
    var bag: DisposeBag = DisposeBag()
    var viewModel: CartCellViewModel? {
        didSet {
            updateCell()
        }
    }
    
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
        let cart = viewModel.cart.compactMap { $0 }
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
    }
}

extension CartTableViewCell {
    private struct Define {
        static var cornerRadius: CGFloat = 10
    }
}
