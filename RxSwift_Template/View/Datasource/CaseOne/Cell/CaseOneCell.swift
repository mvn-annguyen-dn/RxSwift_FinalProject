//
//  CaseOneCell.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 04/01/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class CaseOneCell: UITableViewCell {
    
    @IBOutlet private weak var musicImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    var viewModel: CaseOneCellViewModel? {
        didSet {
            updateCell()
        }
    }

    private func updateCell() {
        guard let viewModel = viewModel else { return }
        let music = viewModel.musicBehaviorRelay
            .compactMap { $0 }
        music
            .map(\.name)
            .bind(to: nameLabel.rx.text)
            .disposed(by: viewModel.bag)

        music
            .map(\.artworkUrl100).subscribe(onNext: { element in
                UIImage.dowloadImageWithRxSwift(url: element ?? "").subscribe { image in
                self.musicImageView.image = image
            }.disposed(by: viewModel.bag)
        })
        .disposed(by: viewModel.bag)
    }
}
