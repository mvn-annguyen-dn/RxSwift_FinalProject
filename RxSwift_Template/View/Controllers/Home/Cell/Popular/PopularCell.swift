//
//  PopularCell.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 03/02/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class PopularCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var bag: DisposeBag = DisposeBag()
    var viewModel: PopularCellViewModel? {
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
        viewModel.populars.asDriver(onErrorJustReturn: []).drive(collectionView.rx.items(cellIdentifier: Define.cellName, cellType: PopularCollectionViewCell.self)) { index, element, cell in
            cell.viewModel = viewModel.viewModelForItem(popularProduct: element)
        }
        .disposed(by: bag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PopularCell: UICollectionViewDelegateFlowLayout {
    
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
extension PopularCell {
    private struct Define {
        static var cellName: String = String(describing: PopularCollectionViewCell.self)
        static var width: CGFloat = UIScreen.main.bounds.width / 2 - 15
        static var height: CGFloat = 330
        static var sizeLayout: CGFloat = 10
    }
}
