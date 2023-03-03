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
        bindingViewModel()
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
        viewModel.carts
            .bind(to: tableView.rx.items(cellIdentifier: Define.cellName, cellType: CartTableViewCell.self)) { [weak self] index, element, cell in
                guard let this = self else { return }
                cell.viewModel = this.viewModel.viewModelForItem(cart: element)
                
                cell.rx
                    .increase
                    .subscribe(onNext: {
                        let numberItemCart = (element.quantity ?? 0) + 1
                        this.updateCart(orderId: element.id ?? 0, quantity: numberItemCart)
                    })
                    .disposed(by: cell.bag)
                
                cell.rx
                    .decrease
                    .subscribe(onNext: {
                        let numberItemCart = (element.quantity ?? 0) - 1
                        if numberItemCart != 0 {
                            this.updateCart(orderId: element.id ?? 0, quantity: numberItemCart)
                        } else {
                            this.removeCart()
                            this.updateCart(orderId: element.id ?? 0, quantity: numberItemCart)
                        }
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
                    })
                    .disposed(by: cell.bag)
            }
            .disposed(by: bag)
    }
    
    private func updatePriceInfoView() {
        let formatter = NumberFormatter()
        formatter.rx.locale.onNext(Locale.current)
        formatter.rx.numberStyle.onNext(.currency)
        
        viewModel.carts
            .subscribe(onNext: { cart in
                let selectedItem = "Item selected: \(cart.count)"
                self.selectedItemLabel.rx
                    .text
                    .onNext(selectedItem)
                
                let total = cart.reduce(0) {retVal, value in
                    retVal + ((value.quantity ?? 0) * (value.price ?? 0))
                }
                if let formattedTipAmount = formatter.string(from: total as NSNumber) {
                    self.totalPriceLabel.rx
                        .text
                        .onNext("\(formattedTipAmount)")
                }
            })
            .disposed(by: bag)
    }
    
    private func animationLoadTable() {
        UIView.transition(with: tableView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
    }
    
    private func configUI() {
        priceInfoView.layer
            .rx
            .cornerRadius
            .onNext(Define.cornerRadius)
        priceInfoView.layer
            .rx
            .maskedCorners
            .onNext(Define.maskedCorners)
        priceInfoView.layer
            .rx
            .shadowColor
            .onNext(Define.shadowColor)
        priceInfoView.layer
            .rx
            .shadowOpacity
            .onNext(Define.shadowOpacity)
        priceInfoView.layer
            .rx
            .shadowOffset
            .onNext(Define.shadowOffset)
        priceInfoView.layer
            .rx
            .shadowRadius
            .onNext(Define.shadowRadius)
        priceInfoView.layer
            .rx
            .masksToBounds
            .onNext(false)
        checkOutButton.layer
            .rx
            .cornerRadius
            .onNext(Define.cornerRadius)
        
        let tapView = UITapGestureRecognizer()
        tapView.addTarget(self, action: #selector(showHideViewDetail))
        priceInfoView.addGestureRecognizer(tapView)
    }
    func bindingViewModel() {
        viewModel.carts
            .map { !$0.isEmpty }
            .bind(to: emptyView.rx.isHidden)
            .disposed(by: bag)
        
        viewModel.carts
            .subscribe(onNext: { _ in
                self.animationLoadTable()
            })
            .disposed(by: bag)
        
        updatePriceInfoView()
    }
    
    private func getCart() {
        viewModel.getApiCart()
    }
    
    private func removeCart() {
        guard let indexPath = tableView.indexPath(for: CartTableViewCell())
        else {
            return
        }
        var removeCart: [Cart] = []
        viewModel.carts.subscribe(onNext: { carts in
            removeCart = carts
            removeCart.remove(at: indexPath.row)
        })
        .disposed(by: bag)
    }
    
    private func removeAllCart() {
        var removeAllCart: [Cart] = []
        viewModel.carts.subscribe(onNext: { carts in
            print("phong remove All Cart")
            removeAllCart = carts
            removeAllCart.removeAll()
        })
        .disposed(by: bag)
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
            self.removeAllCart()
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
            this.viewModel.carts.subscribe(onNext: { carts in
                this.deleteCart(orderId: carts[indexPath.row].id ?? 0)
            })
            .disposed(by: this.bag)
            completionHandler(true)
        }
        delete.backgroundColor = .white
        return UISwipeActionsConfiguration(actions: [])
    }
}
