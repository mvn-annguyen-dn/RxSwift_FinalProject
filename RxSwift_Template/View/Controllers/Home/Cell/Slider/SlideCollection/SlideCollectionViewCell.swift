//
//  SlideCollectionViewCell.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 03/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class SlideCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var shopImageView: UIImageView!
    @IBOutlet private weak var nameShopLabel: UILabel!
    
    // MARK: - Properties
    private var bag: DisposeBag = DisposeBag()
    var viewModel: SlideCollectionViewCellViewModel? {
        didSet {
            updateCell()
        }
    }
    
    private func updateCell() {
        guard let viewModel = viewModel else { return }
        let shop = viewModel.shop.compactMap { $0 }
        shop.map(\.nameShop)
            .bind(to: nameShopLabel.rx.text)
            .disposed(by: bag)
        
        shop.map(\.imageShop).subscribe { image in
            self.shopImageView.image = UIImage(named: image ?? "")
        }
        .disposed(by: bag)
    }
    
}
