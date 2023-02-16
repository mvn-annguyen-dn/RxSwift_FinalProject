//
//  FavoriteViewController.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 10/02/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxRealm
import RealmSwift

final class FavoriteViewController: BaseViewController, UIScrollViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var bag: DisposeBag = DisposeBag()
    var viewModel: FavoriteViewModel = FavoriteViewModel()
    private var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigation()
        configTableView()
        configDatasourcce()
        setUpObserve()
    }
    
    // MARK: - Private func
    private func configNavigation() {
        setTitleNavigation(type: .favorite)
    }
    
    private func configTableView() {
        let nib = UINib(nibName: Define.cellName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Define.cellName)
        tableView.rx.setDelegate(self).disposed(by: bag)
    }
    
    private func configDatasourcce() {
        viewModel.favoriteProducts.bind(to: tableView.rx.items(cellIdentifier: Define.cellName, cellType: FavoriteTableViewCell.self)) { index, element, cell in
            cell.viewModel = self.viewModel.viewModelForItem(index: index)
            cell.rx.didTap.subscribe(onNext: {
                self.viewModel.deleteProductInRealm(id: element.id)
            })
            .disposed(by: cell.bag)
        }
        .disposed(by: bag)
    }
    
    private func setUpObserve() {
        do {
            let realm = try Realm()
            notificationToken = realm.objects(Product.self).observe({ [weak self] (_) in
                guard let this = self else { return }
                this.viewModel.isFavorite(product: self?.viewModel.favoriteProduct.value ?? Product())
                    .subscribe(onNext: { [weak self] isFavorite in
                        guard let this = self else { return }
                        if isFavorite {
                            this.tableView.reloadData()
                        } else {
                            this.normalAlert(message: "No Data")
                        }
                    })
                    .disposed(by: self?.bag ?? DisposeBag())
            })
        } catch {
            normalAlert(message: "Can't reload data")
        }
    }
}

extension FavoriteViewController {
    private struct Define {
        static var cellName: String = String(describing: FavoriteTableViewCell.self)
    }
}

extension Reactive where Base: FavoriteTableViewCell {
    
    var delegate : DelegateProxy<FavoriteTableViewCell, FavoriteTableViewCellDelegate> {
        return FavoriteTableViewCellDelegateProxy.proxy(for: base)
    }
    
    var didTap: Observable<Void> {
        return delegate.methodInvoked(#selector(FavoriteTableViewCellDelegate.didTapCell(_:)))
            .map { parameters in
                return parameters[0] as? Void ?? ()
            }
    }
}

