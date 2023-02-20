//
//  RecommendCell.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 03/02/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class RecommendCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var viewAllLabel: UILabel!
    
    // MARK: - Properties
    private var bag: DisposeBag = DisposeBag()
    var viewModel: RecommendCellViewModel? {
        didSet {
            configDataSource()
        }
    }
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configCollectionView()
    }
    
    // MARK: - Private func
    private func configCollectionView() {
        let cellNib = UINib(nibName: Define.cellName, bundle: Bundle.main)
        collectionView.register(cellNib, forCellWithReuseIdentifier: Define.cellName)
        collectionView.rx.setDelegate(self).disposed(by: bag)
    }
    
    private func configDataSource() {
        guard let viewModel = viewModel else { return }
        viewModel.recommends.bind(to: collectionView.rx.items(cellIdentifier: Define.cellName, cellType: RecommendCollectionViewCell.self)) { index, element, cell in
            cell.viewModel = viewModel.viewModelForItem(recommendProduct: element)
        }
        .disposed(by: bag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RecommendCell:  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Define.width, height: Define.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Define.sizeLayout, left: Define.sizeLayout, bottom: Define.sizeLayout, right: Define.sizeLayout)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Define.sizeLayout
    }
}

// MARK: - Define
extension RecommendCell {
    private struct Define {
        static var cellName: String = String(describing: RecommendCollectionViewCell.self)
        static var width: CGFloat = UIScreen.main.bounds.width
        static var height: CGFloat = 180
        static var sizeLayout: CGFloat = 0
    }
}