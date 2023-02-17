//
//  RecommendCollectionViewCell.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 03/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class RecommendCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var cellView: UIView!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var nameProductLabel: UILabel!
    @IBOutlet private weak var priceProductLabel: UILabel!
    @IBOutlet private weak var shopLabel: UILabel!
    
    // MARK: - Properties
    private var bag: DisposeBag = DisposeBag()
    var viewModel: RecommendCollectionViewCellViewModel? {
        didSet {
            updateCell()
        }
    }
    
    private func updateCell() {
        guard let viewModel = viewModel else { return }
        let recommemd = viewModel.recommend.compactMap { $0 }
        recommemd.map(\.name)
            .bind(to: nameProductLabel.rx.text)
            .disposed(by: bag)
        
        recommemd.map(\.content)
            .bind(to: shopLabel.rx.text)
            .disposed(by: bag)
        
        recommemd.map(\.category?.nameCategory)
            .bind(to: priceProductLabel.rx.text)
            .disposed(by: bag)
        
        recommemd.map(\.imageProduct)
            .bind(to: productImageView.rx.imageCustomBinder)
            .disposed(by: bag)
    }
}
