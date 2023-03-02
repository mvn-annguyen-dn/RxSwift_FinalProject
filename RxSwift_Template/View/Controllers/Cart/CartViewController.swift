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
    private var isShowViewDetail: Bool = true
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigation()
        configTableView()
        configDatasourcce()
        configUI()
        getCart()
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
        tableView.rx
            .setDelegate(self)
            .disposed(by: bag)
    }
    
    private func configDatasourcce() {
        viewModel.carts.bind(to: tableView.rx.items(cellIdentifier: Define.cellName, cellType: CartTableViewCell.self)) { [weak self] index, element, cell in
            guard let this = self else { return }
            cell.viewModel = this.viewModel.viewModelForItem(index: index)
            
            cell.rx
                .increase
                .subscribe(onNext: {
                    this.updateCart(orderId: element.id ?? 0, quantity: (element.quantity ?? 0) + 1)
                    this.updatePriceInfoView()
                })
                .disposed(by: cell.bag)
            
            cell.rx
                .decrease
                .subscribe(onNext: {
                    let numberItemCart = (element.quantity ?? 0) - 1
                    if numberItemCart != 0 {
                        this.updateCart(orderId: element.id ?? 0, quantity: numberItemCart)
                    } else {
                        var deleteCart = this.viewModel.carts.value
                        deleteCart.remove(at: index)
                        this.viewModel.carts.accept(deleteCart)
                        this.updateCart(orderId: element.id ?? 0, quantity: numberItemCart)
                    }
                    this.updatePriceInfoView()
                })
                .disposed(by: cell.bag)
            
            cell.rx
                .inputQuantity
                .subscribe(onNext: { quantity in
                    if quantity.isNumeric {
                        this.updateCart(orderId: element.id ?? 0, quantity: Int(quantity) ?? 0)
                    } else {
                        this.normalAlert(message: "Format invalid")
                    }
                    this.updatePriceInfoView()
                })
                .disposed(by: cell.bag)
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
        
        viewModel.carts
            .subscribe(onNext: { cart in
                let selectedItem = "Item selected: \(cart.count)"
                self.selectedItemLabel.rx.text.onNext(selectedItem)
            })
            .disposed(by: bag)
        
        if let formattedTipAmount = formatter.string(from: totalPrice.value as NSNumber) {
            totalPriceLabel.rx.text.onNext("\(formattedTipAmount)")
        }
    }
    
    private func animationLoadTable() {
        UIView.transition(with: tableView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
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
        
        let tapView = UITapGestureRecognizer()
        tapView.addTarget(self, action: #selector(showHideViewDetail))
        priceInfoView.addGestureRecognizer(tapView)
    }
    
    private func getCart() {
        viewModel.getApiCart()
        viewModel.checkCart
            .distinctUntilChanged()
            .bind(to: emptyView.rx.isHidden)
            .disposed(by: bag)
        updatePriceInfoView()
        animationLoadTable()
    }
    
    // MARK: - Objc methods
    @objc private func showHideViewDetail(sender: UITapGestureRecognizer) {
        UIView.transition(with: checkOutButton, duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
            self.checkOutButton.rx
                .isHidden
                .onNext(self.isShowViewDetail)
            self.isShowViewDetail = !self.isShowViewDetail
        })
    }
    
    // MARK: - Objc func
    @objc private func returnButtonTouchUpInside() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteButtonTouchUpInside() {
        let refreshAlert = UIAlertController(title: "Delete", message: "Do you wanna delete all products in cart?", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            var deleteCart = self.viewModel.carts.value
            deleteCart.removeAll()
            self.viewModel.carts.accept(deleteCart)
            self.animationLoadTable()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
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

extension CartViewController {
    
    private func updateCart(orderId: Int, quantity: Int) {
        viewModel.requestUpdateCart(orderId: orderId, quantity: quantity).subscribe { result in
            switch result {
            case .success(_):
                self.getCart()
            case .failure(let error):
                self.normalAlert(message: error.localizedDescription)
            }
        }
        .disposed(by: bag)
    }
    
    private func deleteCart(orderId: Int) {
        viewModel.requestDeleteCart(orderId: orderId).subscribe { result in
            switch result {
            case .success(_):
                self.getCart()
            case .failure(let error):
                self.normalAlert(message: error.localizedDescription)
            }
        }
        .disposed(by: bag)
    }
}

extension Reactive where Base: CartTableViewCell {
    
    var delegate : DelegateProxy<CartTableViewCell, CartTableViewCellDelegate> {
        return CartTableViewCellDelegateProxy.proxy(for: base)
    }
    
    var increase: Observable<Void> {
        return delegate.methodInvoked(#selector(CartTableViewCellDelegate.increase(_:)))
            .map { parameters in
                return parameters[0] as? Void ?? ()
            }
    }
    
    var decrease: Observable<Void> {
        return delegate.methodInvoked(#selector(CartTableViewCellDelegate.decrease(_:)))
            .map { parameters in
                return parameters[0] as? Void ?? ()
            }
    }
    
    var inputQuantity: Observable<String> {
        return delegate.methodInvoked(#selector(CartTableViewCellDelegate.inputQuantity(_:quantity:)))
            .map { parameters in
                return parameters[1] as? String ?? ""
            }
    }
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let this = self else { return }
            this.deleteCart(orderId: self?.viewModel.carts.value[indexPath.row].id ?? 0)
            completionHandler(true)
        }
        delete.backgroundColor = .white
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
