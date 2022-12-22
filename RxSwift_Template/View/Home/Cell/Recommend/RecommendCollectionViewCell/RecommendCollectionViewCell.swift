//
//  RecommendCollectionViewCell.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 14/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

final class RecommendCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var nameProductLabel: UILabel!
    @IBOutlet private weak var priceProductLabel: UILabel!
    @IBOutlet private weak var shopLabel: UILabel!
    @IBOutlet private weak var recommendCellView: UIView!

    var viewModel: RecommendCollectionViewCellViewModel? {
        didSet {
            updateCell()
        }
    }

    private func updateCell() {
        guard let viewModel = viewModel else { return }
        viewModel.musicBehaviorRelay.asObservable()
            .map { $0.name }
            .bind(to: nameProductLabel.rx.text)
            .disposed(by: viewModel.bag)
        viewModel.musicBehaviorRelay.asObservable()
            .map { $0.artistName }
            .bind(to: priceProductLabel.rx.text)
            .disposed(by: viewModel.bag)
        viewModel.musicBehaviorRelay.asObservable().map { $0.artworkUrl100 ?? "" }.subscribe(onNext: { element in
            UIImage.dowloadImageWithRxSwift(url: element).subscribe { image in
                self.productImageView.image = image
            }.disposed(by: viewModel.bag)
        })
        .disposed(by: viewModel.bag)
    }
}
