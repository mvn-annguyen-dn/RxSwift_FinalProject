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
            let indexPath = IndexPath(item: index, section: 0)
            cell.viewModel = self.viewModel.getDataRecommendCell(indexPath: indexPath)
            if let lastIndexVisible = self.tableView.indexPathsForVisibleRows,
               lastIndexVisible.count == index {
                self.tableView.reloadData()
            }
        }
        .disposed(by: viewModel.bag)
    
//        tableView.delegate = self
//        tableView.dataSource = self
    }

    private func callAPI() {
        viewModel.getApiMusic()
            .subscribe { [weak self] data in
                guard let this = self else { return }
                this.viewModel.musicBehaviorRelay.accept(data.results ?? [])
                this.tableView.reloadData()
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: viewModel.bag)
    }
}

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
