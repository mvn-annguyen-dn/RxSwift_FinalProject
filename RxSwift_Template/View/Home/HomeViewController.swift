//
//  HomeViewController.swift
//  RxSwift_Template
//
//  Created by An Nguyen Q. VN.Danang on 29/11/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class HomeViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: HomeViewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        callAPI()
        configTableView()
    }

    private func configTableView() {
        title = "Home"
        let recommendCell = UINib(nibName: "RecommendCell", bundle: Bundle.main)
        tableView.register(recommendCell, forCellReuseIdentifier: "RecommendCell")
        tableView.rx.setDelegate(self).disposed(by: viewModel.bag)
        
        viewModel.musicBehaviorRelay.bind(to: tableView.rx.items(cellIdentifier: "RecommendCell", cellType: RecommendCell.self)) { index, element, cell in
            cell.viewModel = self.viewModel.getDataRecommendCell(index: index)
        }
        .disposed(by: viewModel.bag)
    }
    
    private func callAPI() {
        viewModel.loadApiMusic().subscribe { result in
            switch result {
            case .success( _): 
                self.viewModel.musicBehaviorRelay
                    .map { _ in () }
                    .bind(to: self.tableView.rx.reloadData())
                    .disposed(by: self.viewModel.bag)
            case .failure(let error):
                ApiError.error(error.localizedDescription)
            }
        }
        .disposed(by: viewModel.bag)
    }
}

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

extension Reactive where Base: UITableView {
    func reloadData() -> Binder<Void> {
        Binder(base) { tableView, _ in
            tableView.reloadData()
        }
    }
}
