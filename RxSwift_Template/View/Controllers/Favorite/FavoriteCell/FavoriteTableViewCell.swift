//
//  FavoriteTableViewCell.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 10/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var itemSubLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    private var bag: DisposeBag = DisposeBag()
    var viewModel: FavoriteTableCellViewModel? {
        didSet {
            updateCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    
    // MARK: - Private method
    private func configUI() {
        itemImageView.layer.rx.borderWidth.onNext(Define.borderWidth)
        itemImageView.layer.rx.cornerRadius.onNext(Define.cornerRadius)
        itemImageView.layer.rx.borderColor.onNext(Define.borderColor)
    }
    
    private func updateCell() {
        guard let viewModel = viewModel else { return }
        let product = viewModel.favoriteProduct.compactMap { $0 }

        product.map(\.name)
            .bind(to: itemNameLabel.rx.text)
            .disposed(by: bag)
        
        product.map(\.category?.shop?.nameShop)
            .bind(to: itemSubLabel.rx.text)
            .disposed(by: bag)
        
        product.map(\.imageProduct)
            .flatMap { DownloadImage.shared.dowloadImageWithRxSwift(url: $0 ) }
            .bind(to: itemImageView.rx.image)
            .disposed(by: bag)
    }
    
}

// MARK: - Define
extension FavoriteTableViewCell {
    private struct Define {
        static var borderWidth: CGFloat = 1.0
        static var cornerRadius: CGFloat = 10
        static var borderColor: CGColor = .init(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
    }
}