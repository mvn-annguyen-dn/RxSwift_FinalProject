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

    let bag: DisposeBag = DisposeBag()
    var viewModel: RecommendCollectionViewCellViewModel? {
        didSet {
            updateCell()
        }
    }

    private func updateCell() {
        ApiManager.shared.downloadImage(url: viewModel?.music.artworkUrl100 ?? "") { [weak self] image in
            guard let this = self else { return }
            this.productImageView.image = image
        }
        nameProductLabel.text = viewModel?.music.artistName
        priceProductLabel.text = viewModel?.music.name
        shopLabel.text = viewModel?.music.copyright
    }
}
