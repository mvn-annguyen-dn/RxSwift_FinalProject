//
//  SearchCollectionViewCell.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 07/02/2023.
//

import UIKit
import RxSwift

final class SearchCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productImageview: UIImageView!
    
    // MARK: - Properties
    var viewModel: SearchCellViewModel? {
        didSet {
            updateUI()
        }
    }
    var cellBag: DisposeBag = DisposeBag()
    
    // MARK: - Override methods
    override func prepareForReuse() {
        super.prepareForReuse()
        cellBag = DisposeBag()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.rx
            .borderWidth
            .onNext(Define.borderWidth)
        contentView.layer.rx
            .cornerRadius
            .onNext(Define.cornerRadius)
        productImageview.layer.rx
            .cornerRadius
            .onNext(Define.cornerRadius)
        productImageview.layer.rx
            .maskedCorners
            .onNext(Define.maskedCorners)
    }
    
    // MARK: - Override methods
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        let product = viewModel.productBehaviorRelay.compactMap { $0 }
        
        product
            .map(\.imageProduct)
            .subscribe(onNext: { string in
                self.productImageview.dowloadImageWithRxSwift(url: string)
                    .bind(to: self.productImageview.rx.image)
                    .disposed(by: self.cellBag)
            })
            .disposed(by: cellBag)

        product
            .map(\.name)
            .bind(to: productNameLabel.rx.text)
            .disposed(by: cellBag)
    }
}

// MARK: - Define
extension SearchCollectionViewCell {
    private struct Define {
        static var borderWidth: CGFloat = 1.0
        static var cornerRadius: CGFloat = 20
        static var maskedCorners: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}
