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

// MARK: Delegate Proxy Cell
@objc
protocol PopularCellDelegate {
    @objc optional func cell(_ cell: PopularCell, product: Product)
}

final class PopularCellDelegateProxy:
     DelegateProxy<PopularCell, PopularCellDelegate>,
     DelegateProxyType,
     PopularCellDelegate {

     static func registerKnownImplementations() {
         self.register { parent in
             PopularCellDelegateProxy(parentObject: parent, delegateProxy: self)
         }
     }

     static func currentDelegate(for object: PopularCell) -> PopularCellDelegate? {
         return object.delegate
     }

     static func setCurrentDelegate(_ delegate: PopularCellDelegate?, to object: PopularCell) {
         object.delegate = delegate
     }
 }

// MARK: Cell View
final class PopularCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var bag: DisposeBag = DisposeBag()
    weak var delegate: PopularCellDelegate?
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
        collectionView.rx
            .setDelegate(self)
            .disposed(by: bag)
    }
    
    private func configDataSource() {
        guard let viewModel = viewModel else { return }
        viewModel.populars
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(cellIdentifier: Define.cellName, cellType: PopularCollectionViewCell.self)) { index, element, cell in
                cell.viewModel = viewModel.viewModelForItem(index: index)
            }
            .disposed(by: bag)
        
        collectionView.rx.modelSelected(Product.self)
            .subscribe(onNext: { [weak self] event in
                guard let this = self else { return }
                this.delegate?.cell?(this, product: event)
            })
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
