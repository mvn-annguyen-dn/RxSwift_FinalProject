//
//  RecommendCell.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 14/12/2022.
//

import UIKit
import RxCocoa
import RxSwift

final class RecommendCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var viewAllLabel: UILabel!

    var viewModel: RecommendCellViewModel? {
        didSet {
            setupCollectionView()
            collectionView.reloadData()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.bag = DisposeBag()
    }
    
    private func setupCollectionView() {
        guard let viewModel = viewModel else { return }
        let cellNib = UINib(nibName: "RecommendCollectionViewCell", bundle: Bundle.main)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "RecommendCollectionViewCell")
        collectionView.rx.setDelegate(self).disposed(by: viewModel.bag)

        viewModel.musicBehaviorRelays.bind(to: collectionView.rx.items(cellIdentifier: "RecommendCollectionViewCell", cellType: RecommendCollectionViewCell.self)) { (index, element, cell) in
            cell.viewModel = self.viewModel?.getDataRecommendCollectionCell(index: index)
        }
        .disposed(by: viewModel.bag)
    }
}

extension RecommendCell:  UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 180)
    }
}
