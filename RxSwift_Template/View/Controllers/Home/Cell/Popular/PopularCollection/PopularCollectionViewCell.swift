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
        
        popular.map(\.imageProduct)
            .bind(to: productImageView.rx.downloadImage)
            .disposed(by: bag)
    }
}

extension Reactive where Base: UIImageView {

    var downloadImage: Binder<String?> {
        return Binder(self.base) { imageView, stringImage in
            UIImageView.dowloadImageWithRxSwift(url: stringImage ?? "")
                .subscribe { image in
                    imageView.rx.image.onNext(image)
                }
        }
    }
}