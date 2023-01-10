//
//  CaseFourViewController.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 04/01/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class CaseFourViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: CaseFourViewModel = CaseFourViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        callApi()
        configTableView()
        configDataSource()
    }

    private func callApi() {
        viewModel.loadApiMusic()
    }

    private func configTableView() {
        title = "Multiple Section with multiple Cell Type"
        let firstCell = UINib(nibName: "FirstCell", bundle: Bundle.main)
        tableView.register(firstCell, forCellReuseIdentifier: "FirstCell")
        let secondCell = UINib(nibName: "CaseOneCell", bundle: Bundle.main)
        tableView.register(secondCell, forCellReuseIdentifier: "CaseOneCell")

        tableView.rx.modelSelected(HomeSectionItem.self)
            .asDriver()
            .drive(onNext: { model in
                switch model {
                case .itemOne(music: _):
                    self.presentAlert("", message: "Alert multiple section One")
                case .itemTwo(title: let title, music: _):
                    self.presentAlert(title, message: "Alert multiple section Two")
                }
            })
            .disposed(by: viewModel.bag)
    }
    
    private func configDataSource() {
        let datasource = RxTableViewSectionedReloadDataSource<HomeSectionModel>(configureCell: { datasource, tableview, indexpath, item in
            switch datasource[indexpath] {
            case .itemOne(music: let music):
                guard let cell = tableview.dequeueReusableCell(withIdentifier: "CaseOneCell", for: indexpath) as? CaseOneCell else { return UITableViewCell() }
                cell.viewModel = self.viewModel.getDataFirstCell(music: music, indexPath: indexpath)
                return cell
            case .itemTwo(title: let title, music: let music):
                guard let cell = tableview.dequeueReusableCell(withIdentifier: "FirstCell", for: indexpath) as? FirstCell else { return UITableViewCell() }
                cell.viewModel = self.viewModel.getDataSecondCell(music: music, indexPath: indexpath, title: title)
                return cell
            }
        }, titleForHeaderInSection: { dataSource, index in
            let section = dataSource[index]
            return section.title
        })
        
        viewModel.sectionModels.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: viewModel.bag)
    }

    private func presentAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: "\(title) Selected", message: "Message \(message)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
