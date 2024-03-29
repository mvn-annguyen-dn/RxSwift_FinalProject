//
//  DetailViewController.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 10/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var contentProductView: UIView!
    @IBOutlet private weak var addProductView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var nameProductLabel: UILabel!
    @IBOutlet private weak var priceProductLabel: UILabel!
    @IBOutlet private weak var categoryProductLabel: UILabel!
    @IBOutlet private weak var shopProductLabel: UILabel!
    @IBOutlet private weak var descriptionProductLabel: UILabel!
    @IBOutlet private weak var addToCartButton: UIButton!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var totalProductLabel: UILabel!
    @IBOutlet private weak var minusButton: UIButton!
    @IBOutlet private weak var plusButton: UIButton!
    
    // MARK: - Properties
    var viewModel: DetailViewModel?
    private let disposeBag = DisposeBag()
    private var timer: Timer?
    private var favoriteButton: UIBarButtonItem?
    private var quantity: BehaviorRelay<Int> = .init(value: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigation()
        configUI()
        configCollectionView()
        updateQuantity()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabbar()
    }
    
    //MARK: Private Methods
    private func configNavigation() {
        setTitleNavigation(type: .detail)
        
        //Add Button
        setLeftBarButton(imageString:  "icon-back", tintColor: .black, action: #selector(backButtonTouchUpInside))
        favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(favoriteButtonTouchUpInside))
        navigationItem.rx
            .rightBarButtonItem
            .onNext(favoriteButton)
    }
    
    private func configUI() {
        configSubView()
        updateUI()
        addGeture()
    }
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        let product = viewModel.productSubject.compactMap { $0 }
        
        product
            .map(\.name)
            .bind(to: nameProductLabel.rx.text)
            .disposed(by: disposeBag)
        
        product
            .map(\.price)
            .subscribe({ price in
                self.priceProductLabel.text = "$ \(price.element ?? 0)"
            })
            .disposed(by: disposeBag)
        
        product
            .map(\.category?.nameCategory)
            .bind(to: categoryProductLabel.rx.text)
            .disposed(by: disposeBag)
        
        product
            .map(\.category?.shop?.nameShop)
            .bind(to: shopProductLabel.rx.text)
            .disposed(by: disposeBag)
        
        product
            .map(\.content)
            .bind(to: descriptionProductLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func updateColorFavorite(isFavorite: Bool) {
        #warning("Handle Later")
        favoriteButton?.rx.tintColor.onNext(isFavorite ? .red : .black)
    }
    
    private func configCollectionView() {
        guard let viewModel = viewModel else { return }
        let slideNib = UINib(nibName: Define.cellName, bundle: Bundle.main)
        collectionView.register(slideNib, forCellWithReuseIdentifier: Define.cellName)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.listImage
            .bind(to: collectionView.rx.items) { [weak self] (cv, index, element) in
                let indexPath = IndexPath(row: index, section: 0)
                guard let this = self,
                      let cell = this.collectionView.dequeueReusableCell(withReuseIdentifier: Define.cellName, for: indexPath) as? CarouselCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.viewModel = this.viewModel?.viewModelForItem(at: indexPath)
                return cell
            }
            .disposed(by: disposeBag)
        startTimer()
    }
    
    private func configSubView() {
        addProductView.layer.rx
            .cornerRadius
            .onNext(Define.cornerRadius)
        addProductView.layer.rx
            .maskedCorners
            .onNext(Define.maskedCorners)
        addProductView.layer.rx
            .shadowColor
            .onNext(Define.shadowColor)
        addProductView.layer.rx
            .shadowOpacity
            .onNext(Define.shadowOpacity)
        addProductView.layer.rx
            .shadowOffset
            .onNext(Define.shadowOffset)
        addProductView.layer.rx
            .shadowRadius
            .onNext(Define.shadowRadius)
        
        contentProductView.rx
            .clipsToBounds
            .onNext(true)
        contentProductView.layer.rx
            .cornerRadius
            .onNext(Define.cornerRadius)
        contentProductView.layer.rx
            .maskedCorners
            .onNext(Define.maskedCorners)
        
        addToCartButton.layer.rx
            .cornerRadius
            .onNext(Define.cornerRadius)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: Define.timerIntervar, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
    }

    private func updateQuantity() {
        guard let viewModel = viewModel else { return }
        
        quantity.subscribe(onNext: { [weak self] value in
            guard let this = self else { return }
            let total = value * (viewModel.productSubject.value?.price ?? 0)
            this.quantityLabel.text = "\(this.quantity.value)"
            this.totalProductLabel.text = "Total: $\(total)"
        })
        .disposed(by: disposeBag)
    }

    // MARK: - Action methods
    private func addGeture() {
        addToCartButton.rx.tap
            .subscribe(onNext: { _ in
                #warning("Handle later")
            })
            .disposed(by: disposeBag)
        
        minusButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let this = self else { return }
                this.quantity.accept(this.quantity.value == 1 ? 1 : this.quantity.value - 1)
            })
            .disposed(by: disposeBag)

        plusButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let this = self else { return }
                this.quantity.accept(this.quantity.value + 1)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Objc methods
    @objc private func favoriteButtonTouchUpInside() {
        #warning("Handle later")
        updateColorFavorite(isFavorite: !false)
    }
    
    @objc private func backButtonTouchUpInside() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func moveToNextIndex() {
        guard let viewModel = viewModel else { return }
        viewModel.isCheck
            .map { _ in viewModel.currentIndex.value < (viewModel.listImage.value.count - 1) }
            .drive { value in
                viewModel.currentIndex.accept(value ? viewModel.currentIndex.value + 1 : 0)
                self.collectionView.rx.scrollToItem.onNext(IndexPath(row: viewModel.currentIndex.value, section: 0))
            }
            .disposed(by: disposeBag)
    }
}

extension DetailViewController {
    private struct Define {
        static var cellName: String = String(describing: CarouselCollectionViewCell.self)
        static var insetDefault: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static var lineSpacingDefault: CGFloat = 0
        static var cornerRadius: CGFloat = 25
        static var shadowOffset: CGSize = CGSize(width: 3, height: 0)
        static var shadowOpacity: Float = 1
        static var shadowRadius: CGFloat = 3
        static var shadowColor: CGColor = UIColor.lightGray.cgColor
        static var maskedCorners: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        static var timerIntervar: Double = 2.5
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Define.insetDefault
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Define.lineSpacingDefault
    }
}
