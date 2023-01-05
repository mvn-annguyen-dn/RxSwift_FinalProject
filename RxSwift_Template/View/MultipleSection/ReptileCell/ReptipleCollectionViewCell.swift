//
//  ReptipleCollectionViewCell.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 03/01/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class ReptipleCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var frontCardView: UIView!
    @IBOutlet private weak var cardImageView: UIImageView!
    @IBOutlet private weak var backCardView: UIView!
    
    var viewModel: ReptipleCellViewModel? {
        didSet {
            updateCell()
        }
    }
    
    private var showingBack = false

    var cellBag = DisposeBag()

    override func prepareForReuse() {
        cellBag = DisposeBag()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                guard let this = self else { return }
                UIView.transition(with: this.contentView, duration: 1, options: .transitionFlipFromRight) {
                    this.frontCardView.isHidden = this.showingBack
                    this.backCardView.isHidden = !this.showingBack
                }
                this.showingBack = !this.showingBack
            }
            .disposed(by: cellBag)
    }

    private func updateCell() {
        guard let viewModel = viewModel else { return }
        let card = viewModel.cardRelay.compactMap { $0 }
        card
            .map(\.image)
            .subscribe({ event in
                guard let image = event.element else { return }
                self.cardImageView.image = UIImage(named: image)
            })
            .disposed(by: cellBag)
    }
}
