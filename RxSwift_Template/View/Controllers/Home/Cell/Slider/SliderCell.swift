//
//  SliderCell.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 03/02/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class SliderCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    private var bag: DisposeBag = DisposeBag()
    var viewModel: SliderCellViewModel? {
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
        startTimer()
    }
    
    private func configDataSource() {
        guard let viewModel = viewModel else { return }
        viewModel.shops.bind(to: collectionView.rx.items(cellIdentifier: Define.cellName, cellType: SlideCollectionViewCell.self)) { index, element, cell in
            cell.viewModel = viewModel.viewModelForItem(sliderShop: element)
        }
        .disposed(by: bag)
    }
    
    private func configUI() {
        guard let viewModel = viewModel else { return }
        pageControl.numberOfPages = viewModel.numberOfPage()
    }
    
    private func startTimer() {
        Observable<Int>.interval(.seconds(Define.timerIntervar), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.moveToNextIndex()
            })
            .disposed(by: bag)
    }
    
    // MARK: - Objc methods
    @objc private func moveToNextIndex() {
        guard let viewModel = viewModel else { return }
        if viewModel.currentIndex.value < (viewModel.numberOfPage() - 1) {
            viewModel.currentIndex.accept(viewModel.currentIndex.value + 1)
        } else {
            viewModel.currentIndex.accept(0)
        }
        collectionView.scrollToItem(at: IndexPath(row: viewModel.currentIndex.value, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.rx.currentPage.onNext(viewModel.currentIndex.value)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SliderCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Define.sizeLayout, left: Define.sizeLayout, bottom: Define.sizeLayout, right: Define.sizeLayout)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Define.sizeLayout
    }
}

// MARK: - Define
extension SliderCell {
    private struct Define {
        static var cellName: String = String(describing: SlideCollectionViewCell.self)
        static var timerIntervar: Int = 3
        static var sizeLayout: CGFloat = 0
    }
}
