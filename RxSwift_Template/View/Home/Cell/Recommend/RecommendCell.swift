//
//  RecommendCell.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 14/12/2022.
//

import UIKit
import RxCocoa
import RxSwift

final class RecommendCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var viewAllLabel: UILabel!

    let bag: DisposeBag = DisposeBag()
    var viewModel: RecommendCellViewModel = RecommendCellViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        callAPI()
        setupTableView()
    }

    private func callAPI() {
        viewModel.getApiMusic()
            .subscribe { [weak self] data in
                guard let this = self else { return }
                this.viewModel.musicBehaviorRelay.accept(data.results ?? [])
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: bag)
    }
    
    private func setupTableView() {
        let cellNib = UINib(nibName: "RecommendCollectionViewCell", bundle: Bundle.main)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "RecommendCollectionViewCell")
        collectionView.rx.setDelegate(self).disposed(by: bag)

        viewModel.musicBehaviorRelay.bind(to: collectionView.rx.items(cellIdentifier: "RecommendCollectionViewCell", cellType: RecommendCollectionViewCell.self)) { (index, element, cell) in
//            let indexPath = IndexPath(item: index, section: 0)
            cell.viewModel = self.viewModel.getDataRecommendCell(index: index)

            if let lastIndexVisible = self.collectionView.indexPathsForVisibleItems.last,
               lastIndexVisible.row == index {
                self.collectionView.reloadData()
            }
        }
        .disposed(by: bag)
    }
}

extension RecommendCell:  UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 180)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
