//
//  CaseOneViewController.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 04/01/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class CaseOneViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    var viewModel: CaseOneViewModel = CaseOneViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        callApi()
        configTableView()
    }

    private func configTableView() {
        title = "1 Section with 1 Cell Type"
        let firstCell = UINib(nibName: "CaseOneCell", bundle: Bundle.main)
        tableView.register(firstCell, forCellReuseIdentifier: "CaseOneCell")

        let dataSource = RxTableViewSectionedReloadDataSource<AnimalSection>(configureCell: { datasource, tableview, indexpath, item in
            guard let cell = tableview.dequeueReusableCell(withIdentifier: "CaseOneCell", for: indexpath) as? CaseOneCell else { return UITableViewCell() }
            cell.viewModel = self.viewModel.getDataFirstCell(indexPath: indexpath)
            return cell
        }) {
            dataSource, index in
            return dataSource.sectionModels[index].header
        }

        viewModel.sectionRelay.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: viewModel.bag)
    }

    private func callApi() {
        viewModel.loadApiMusic()
    }
}
