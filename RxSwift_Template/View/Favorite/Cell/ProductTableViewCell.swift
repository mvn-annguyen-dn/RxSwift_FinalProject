//
//  ProductTableViewCell.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 17/01/2023.
//

import UIKit
import RxSwift

final class ProductTableViewCell: UITableViewCell {

    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productSubLabel: UILabel!

    var viewModel: ProductCellViewModel? {
        didSet {
            updateCell()
        }
    }
    var cellBag: DisposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        cellBag = DisposeBag()
    }

    private func updateCell() {
        guard let viewModel = viewModel else { return }
        let product = viewModel.productSubject.compactMap { $0 }

        product.map(\.name)
            .bind(to: productNameLabel.rx.text)
            .disposed(by: cellBag)

        product.map(\.content)
            .bind(to: productSubLabel.rx.text)
            .disposed(by: cellBag)

        product
            .map(\.imageProduct)
            .flatMap { DowloadImage.shared.downloadImage(url: $0) }
            .subscribe { [weak self] image in
                guard let this = self else { return }
                this.productImageView.rx
                    .image
                    .onNext(image)
            }
            .disposed(by: cellBag)

    }
}
