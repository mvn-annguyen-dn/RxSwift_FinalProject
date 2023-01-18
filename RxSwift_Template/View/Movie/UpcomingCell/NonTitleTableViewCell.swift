//
//  UpcomingTableViewCell.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 09/01/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class NonTitleTableViewCell: UITableViewCell {

    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var overviewLabel: UILabel!

    var viewModel: NonTitleCellViewModel? {
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
        let item = viewModel.upcomingItem.compactMap { $0 }

        item
            .map(\.overview)
            .bind(to: overviewLabel.rx.text)
            .disposed(by: cellBag)
        item
            .map(\.posterPath)
            .flatMap { DowloadImage.shared.downloadImage(url: "https://image.tmdb.org/t/p/w500\($0 ?? "")") }
            .subscribe { [weak self] image in
                guard let this = self else { return }
                this.itemImageView.rx
                    .image
                    .onNext(image)
            }
            .disposed(by: cellBag)
    }
}

