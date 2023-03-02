//
//  CartViewController.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 20/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class CartViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var priceInfoView: UIView!
    @IBOutlet private weak var selectedItemLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var checkOutButton: UIButton!
    @IBOutlet private weak var emptyView: UIView!
    
    // MARK: - Properties
    private var bag: DisposeBag = DisposeBag()
    var viewModel: CartViewModel = CartViewModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigation()
        configUI()
        updateUI()
        configTableView()
        configDatasourcce()
        updatePriceInfoView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabbar()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - Private func
    private func configNavigation() {
        setTitleNavigation(type: .cart)
        setLeftBarButton(imageString: "chevron", tintColor: .black, action: #selector(returnButtonTouchUpInside))
        setRightBarButton(imageString: "trash.fill", tintColor: .black, action: #selector(deleteButtonTouchUpInside))
    }
    
    private func  configTableView() {
        let nib = UINib(nibName: Define.cellName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Define.cellName)
    }
    
    private func configDatasourcce() {
        viewModel.carts.bind(to: tableView.rx.items(cellIdentifier: Define.cellName, cellType: CartTableViewCell.self)) { index, element, cell in
            cell.viewModel = self.viewModel.viewModelForItem(index: index)
        }
        .disposed(by: bag)
    }
    
    private func updateUI() {
        emptyView.rx.isHidden.onNext(viewModel.carts.value.isEmpty ? false : true)
    }
    
    private func updatePriceInfoView() {
        let formatter = NumberFormatter()
        formatter.rx.locale.onNext(Locale.current)
        formatter.rx.numberStyle.onNext(.currency)
        let totalPrice = viewModel.totalPriceCarts()
        
        viewModel.carts.subscribe(onNext: { cart in
            let selectedItem = "Item selected: \(cart.count)"
            self.selectedItemLabel.rx.text.onNext(selectedItem)
        })
        .disposed(by: bag)
        
        if let formattedTipAmount = formatter.string(from: totalPrice.value as NSNumber) {
            totalPriceLabel.rx.text.onNext("\(formattedTipAmount)")
        }
    }
    
    private func configUI() {
        priceInfoView.layer.rx.cornerRadius.onNext(Define.cornerRadius)
        priceInfoView.layer.rx.maskedCorners.onNext(Define.maskedCorners)
        priceInfoView.layer.rx.shadowColor.onNext(Define.shadowColor)
        priceInfoView.layer.rx.shadowOpacity.onNext(Define.shadowOpacity)
        priceInfoView.layer.rx.shadowOffset.onNext(Define.shadowOffset)
        priceInfoView.layer.rx.shadowRadius.onNext(Define.shadowRadius)
        priceInfoView.layer.rx.masksToBounds.onNext(false)
        checkOutButton.layer.rx.cornerRadius.onNext(Define.cornerRadius)
    }
    
    // MARK: - Objc func
    @objc private func returnButtonTouchUpInside() {
        #warning("handle later")
    }
    
    @objc private func deleteButtonTouchUpInside() {
        #warning("handle later")
    }
}

// MARK: - Define
extension CartViewController {
    private struct Define {
        static var cellName: String = String(describing: CartTableViewCell.self)
        static var cornerRadius: CGFloat = 20
        static var shadowOffset: CGSize = CGSize(width: 3, height: 0)
        static var shadowOpacity: Float = 1
        static var shadowRadius: CGFloat = 3
        static var shadowColor: CGColor = UIColor.lightGray.cgColor
        static var maskedCorners: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}
