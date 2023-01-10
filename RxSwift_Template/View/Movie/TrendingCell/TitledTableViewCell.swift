//
//  TrendingTableViewCell.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 06/01/2023.
//

import UIKit
import RxCocoa
import RxSwift

final class TitledTableViewCell: UITableViewCell {

    @IBOutlet private weak var musicImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!

    var viewModel: TitledCellViewModel? {
        didSet {
            updateCell()
        }
    }

    var cellBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        cellBag = DisposeBag()
    }

    private func updateCell() {
        guard let viewModel = viewModel else { return }
        let item = viewModel.trendingItem.compactMap { $0 }

        item
            .map(\.title)
            .bind(to: nameLabel.rx.text)
            .disposed(by: cellBag)
        item
            .map(\.overview)
            .bind(to: overviewLabel.rx.text)
            .disposed(by: cellBag)
        item
            .map(\.posterPath)
            .flatMap { DowloadImage.shared.downloadImage(url: "https://image.tmdb.org/t/p/w500\($0 ?? "")") }
            .subscribe { [weak self] image in
                guard let this = self else { return }
                this.musicImageView.rx
                    .image
                    .onNext(image)
            }
            .disposed(by: cellBag)
    }
}
