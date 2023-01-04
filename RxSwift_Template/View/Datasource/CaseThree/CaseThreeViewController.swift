//
//  CaseThreeViewController.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 04/01/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class CaseThreeViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    var viewModel: CaseThreeViewModel = CaseThreeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        callApi()
        configTableView()
    }

    private func callApi() {
        viewModel.loadApiMusic()
    }

    private func configTableView() {
        title = "Multiple Section with 1 Cell Type"
        let firstCell = UINib(nibName: "FirstCell", bundle: Bundle.main)
        tableView.register(firstCell, forCellReuseIdentifier: "FirstCell")
        
        let dataSource = RxTableViewSectionedReloadDataSource<AnimalSection>(configureCell: { datasource, tableview, indexpath, item in
            guard let cell = tableview.dequeueReusableCell(withIdentifier: "FirstCell", for: indexpath) as? FirstCell else { return UITableViewCell() }
            cell.viewModel = self.viewModel.getDataFirstCell(indexPath: indexpath)
            return cell
        }) {
            dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        viewModel.sectionRelay.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: viewModel.bag)
    }
}
