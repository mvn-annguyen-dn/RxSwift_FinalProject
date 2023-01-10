//
//  TitleCollectionViewCell.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 04/01/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class TitleCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var subLabel: UILabel!

    var viewModel: TitleCellViewModel? {
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
        let card = viewModel.cardRelay.compactMap { $0 }
        
        card
            .map(\.name)
            .bind(to: nameLabel.rx.text)
            .disposed(by: cellBag)
        
        card
            .map(\.title)
            .bind(to: subLabel.rx.text)
            .disposed(by: cellBag)
    }
}
