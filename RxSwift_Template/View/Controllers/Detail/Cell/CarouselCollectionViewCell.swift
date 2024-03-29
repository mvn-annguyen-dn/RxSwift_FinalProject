//
//  CarouselCollectionViewCell.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 10/02/2023.
//

import UIKit
import RxSwift

final class CarouselCollectionViewCell: UICollectionViewCell {
    
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
            .flatMap { DownloadImage.shared.dowloadImageWithRxSwift(url: $0) }
            .bind(to: productImageView.rx.image)
            .disposed(by: cellBag)
    }
}
