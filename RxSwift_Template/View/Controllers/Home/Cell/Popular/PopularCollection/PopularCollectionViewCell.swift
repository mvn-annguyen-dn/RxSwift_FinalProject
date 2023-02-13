//
//  PopularCollectionViewCell.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 03/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class PopularCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var nameProductLabel: UILabel!
    @IBOutlet private weak var categotyProductLabel: UILabel!
    @IBOutlet private weak var priceProductLabel: UILabel!
    
    // MARK: - Properties
    private var bag: DisposeBag = DisposeBag()
    var viewModel: PopularCollectionViewCellViewModel? {
        didSet {
            updateCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderWidth = Define.borderWidth
        contentView.layer.cornerRadius = Define.cornerRadius
        productImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        productImageView.layer.cornerRadius = Define.cornerRadius
    }
    
    private func updateCell() {
        guard let viewModel = viewModel else { return }
        let popular = viewModel.popular.compactMap { $0 }
        popular.map(\.name)
            .bind(to: nameProductLabel.rx.text)
            .disposed(by: bag)
        
        popular.map(\.content)
            .bind(to: priceProductLabel.rx.text)
            .disposed(by: bag)
        
        popular.map(\.category?.nameCategory)
            .bind(to: categotyProductLabel.rx.text)
            .disposed(by: bag)
        
        popular.map(\.imageProduct).subscribe { image in
            UIImageView.dowloadImageWithRxSwift(url: image ?? "").subscribe { image in
                self.productImageView.rx.image.onNext(image)
            }
            .disposed(by: self.bag)
        }
        .disposed(by: bag)
    }
}

// MARK: - Define
extension PopularCollectionViewCell {
    private struct Define {
        static var cornerRadius: CGFloat = 20
        static var borderWidth: CGFloat = 1
    }
}

