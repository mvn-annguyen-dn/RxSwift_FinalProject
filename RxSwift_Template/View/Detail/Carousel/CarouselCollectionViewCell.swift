//
//  CarouselCollectionViewCell.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 17/01/2023.
//

import UIKit
import RxSwift

class CarouselCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var productImageView: UIImageView!
    
    // MARK: - Properties
    var viewModel: CarouselCellViewModel? {
        didSet {
            updateCell()
        }
    }
    var cellBag: DisposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        cellBag = DisposeBag()
    }
    
    // MARK: - Private methods
    private func updateCell() {
        guard let viewModel = viewModel else { return }
        viewModel.imageSubject
            .compactMap { $0 }
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
