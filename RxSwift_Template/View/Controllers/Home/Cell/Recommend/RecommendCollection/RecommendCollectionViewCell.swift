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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customViewShadow()
        productImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        productImageView.layer.cornerRadius = Define.cornerRadius
    }
    
    private func customViewShadow() {
        cellView.clipsToBounds = true
        cellView.layer.masksToBounds = false
        cellView.layer.cornerRadius = Define.cornerRadius
        cellView.layer.shadowOffset = CGSize(width: Define.widthShadowOffset, height: Define.heightShadowOffset)
        cellView.layer.shadowColor = Define.shadowColor
        cellView.layer.shadowOpacity = Define.shadowOpacity
        cellView.layer.shadowRadius = Define.shadowRadius
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
        
        recommemd.map(\.imageProduct).subscribe { image in
            UIImageView.dowloadImageWithRxSwift(url: image ?? "").subscribe { image in
                self.productImageView.rx.image.onNext(image)
            }
            .disposed(by: self.bag)
        }
        .disposed(by: bag)
    }
}

// MARK: - Define
extension RecommendCollectionViewCell {
    private struct Define {
        static var cornerRadius: CGFloat = 20
        static var widthShadowOffset: Double = 0
        static var heightShadowOffset: Double = 3
        static var shadowColor = UIColor.lightGray.cgColor
        static var shadowOpacity: Float = 0.3
        static var shadowRadius: CGFloat = 5
    }
}
