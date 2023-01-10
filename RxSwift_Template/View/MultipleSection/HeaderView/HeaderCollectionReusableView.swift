//
//  HeaderCollectionReusableView.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 03/01/2023.
//

import UIKit
import RxSwift

final class HeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet private weak var headerNameLabel: UILabel!

    var viewModel: HeaderCellViewModel? {
        didSet {
            updateHeader()
        }
    }

    var bag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

    private func updateHeader() {
        guard let viewModel = viewModel else { return }
        viewModel.headerOb
            .bind(to: headerNameLabel.rx.text)
            .disposed(by: bag)
    }
    
}
