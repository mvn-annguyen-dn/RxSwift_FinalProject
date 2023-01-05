//
//  FirstCell.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 04/01/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class FirstCell: UITableViewCell {

    @IBOutlet private weak var firstNameLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!

    var viewModel: FirstCellViewModel? {
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
            .bind(to: firstNameLabel.rx.text)
            .disposed(by: viewModel.bag)
        titleLabel.text = viewModel.title
    }
}
