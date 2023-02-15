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
    
    private var timer: Timer?
    
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
            cell.viewModel = viewModel.viewModelForItem(index: index)
        }
        .disposed(by: bag)
    }
    
    private func configUI() {
        guard let viewModel = viewModel else { return }
        pageControl.numberOfPages = viewModel.numberOfPage()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: Define.timerIntervar, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
    }
    
    // MARK: - Objc methods
    @objc private func moveToNextIndex() {
        guard let viewModel = viewModel else { return }
        if viewModel.currentIndex < (viewModel.numberOfPage() - 1) {
            viewModel.currentIndex += 1
        } else {
            viewModel.currentIndex = 0
        }
        collectionView.scrollToItem(at: IndexPath(row: viewModel.currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = viewModel.currentIndex
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SliderCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - Define
extension SliderCell {
    private struct Define {
        static var cellName: String = String(describing: SlideCollectionViewCell.self)
        static var timerIntervar: Double = 2.5
    }
}