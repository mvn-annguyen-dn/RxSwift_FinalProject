//
//  MultipleSectionViewController.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 03/01/2023.
//

import UIKit
import RxSwift
import RxDataSources

final class MultipleSectionViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    var viewModel: MultipleSectionViewModel = MultipleSectionViewModel()
    var disposeBag: DisposeBag = DisposeBag()
    
    let reptileCell: String = String(describing: ReptipleCollectionViewCell.self)
    let titleCell: String = String(describing: TitleCollectionViewCell.self)
    let headerView: String = String(describing: HeaderCollectionReusableView.self)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Multiple Section"
        configTableView()
        viewModel.setUpData()
        configDataSource()
    }

    private func configTableView() {
        let reptileNib = UINib(nibName: reptileCell, bundle: .main)
        collectionView.register(reptileNib, forCellWithReuseIdentifier: reptileCell)
        
        let titleNib = UINib(nibName: titleCell, bundle: .main)
        collectionView.register(titleNib, forCellWithReuseIdentifier: titleCell)
        
        let headerNib = UINib(nibName: headerView, bundle: .main)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerView)
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }

    private func configDataSource() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<MyCardSectionModel>(
            configureCell: { [weak self] dataSource, _, indexPath, item in
                switch dataSource[indexPath] {
                case .frontCard(let frontcard):
                    guard let this = self,
                          let cell = this.collectionView.dequeueReusableCell(withReuseIdentifier: this.reptileCell, for: indexPath) as? ReptipleCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.viewModel = this.viewModel.viewModelForItem(at: frontcard)
                    return cell
                case .backCard(let backcard):
                    guard let this = self,
                          let cell = this.collectionView.dequeueReusableCell(withReuseIdentifier: this.titleCell, for: indexPath) as? TitleCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.viewModel = this.viewModel.viewModelForItem2(at: backcard)
                    return cell
                }
            }, configureSupplementaryView: { [weak self] dataSource, _, _, indexPath in
                guard let this = self,
                      let header = this.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: this.headerView, for: indexPath) as? HeaderCollectionReusableView else {
                    return UICollectionReusableView()
                }
                header.viewModel = this.viewModel.viewHeaderForItem(at: indexPath)
                return header
            }, canMoveItemAtIndexPath: { _, _ in
                    return true
            })
        
        viewModel.dataRelay
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension MultipleSectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 10 , height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 44)
    }
}
