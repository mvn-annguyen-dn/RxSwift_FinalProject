//
//  CaseTwoViewController.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 04/01/2023.
//

import RxSwift
import RxCocoa
import RxDataSources

final class CaseTwoViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: CaseTwoViewModel = CaseTwoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        callApi()
        configTableView()
    }

    private func callApi() {
        viewModel.loadApiMusic()
    }

    private func configTableView() {
        title = "1 Section with Multiple Cell Type"
        let firstCell = UINib(nibName: "FirstCell", bundle: Bundle.main)
        tableView.register(firstCell, forCellReuseIdentifier: "FirstCell")
        let secondCell = UINib(nibName: "CaseOneCell", bundle: Bundle.main)
        tableView.register(secondCell, forCellReuseIdentifier: "CaseOneCell")

        let dataSource = RxTableViewSectionedReloadDataSource<AnimalSection>(configureCell: { datasource, tableview, indexpath, item in
            if indexpath.row == 0 {
                guard let cell = tableview.dequeueReusableCell(withIdentifier: "FirstCell", for: indexpath) as? FirstCell else { return UITableViewCell() }
                cell.viewModel = self.viewModel.getDataFirstCell(indexPath: indexpath)
                return cell
            } else {
                guard let cell = tableview.dequeueReusableCell(withIdentifier: "CaseOneCell", for: indexpath) as? CaseOneCell else { return UITableViewCell() }
                cell.viewModel = self.viewModel.getDataSecondCell(indexPath: indexpath)
                return cell
            }
        }) {
            dataSource, index in
            return dataSource.sectionModels[index].header
        }

        viewModel.sectionRelay.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: viewModel.bag)
    }
}
