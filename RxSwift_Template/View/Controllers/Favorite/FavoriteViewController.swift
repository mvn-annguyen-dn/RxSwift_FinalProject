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

final class FavoriteViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private var bag: DisposeBag = DisposeBag()
    var viewModel: FavoriteViewModel = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configNavigation()
        configTableView()
        configDatasourcce()
        dummyData()
    }
    
    // MARK: - Private func
    private func configNavigation() {
        setTitleNavigation(type: .favorite)
    }
    
    private func configTableView() {
        let nib = UINib(nibName: Define.cellName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Define.cellName)
    }
    
    private func configDatasourcce() {
        viewModel.favoriteProducts.bind(to: tableView.rx.items(cellIdentifier: Define.cellName, cellType: FavoriteTableViewCell.self)) { index, element, cell in
            cell.viewModel = self.viewModel.viewModelForItem(index: index)
        }
        .disposed(by: bag)
    }
    
    private func dummyData() {
        viewModel.dummyData()
    }
}

extension FavoriteViewController {
    private struct Define {
        static var cellName: String = String(describing: FavoriteTableViewCell.self)
    }
}
