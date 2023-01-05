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
    
    let bag = DisposeBag()
    var viewModel: CaseFourViewModel = CaseFourViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        callApi()
        configTableView()
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

        let datasource = RxTableViewSectionedReloadDataSource<HomeSectionModel>(configureCell: { datasource, tableview, indexpath, item in
            switch datasource[indexpath] {
            case let .ItemOne(musics: musics):
                guard let cell = tableview.dequeueReusableCell(withIdentifier: "CaseOneCell", for: indexpath) as? CaseOneCell else { return UITableViewCell() }
                musics.map { music in
                    cell.viewModel = self.viewModel.getDataFirstCell(music: music, indexPath: indexpath)
                }
                return cell
            case let .ItemTwo(title: title, musics: musics):
                guard let cell = tableview.dequeueReusableCell(withIdentifier: "FirstCell", for: indexpath) as? FirstCell else { return UITableViewCell() }
                musics.map { music in
                    cell.titleLabel.text = title
                    cell.viewModel = self.viewModel.getDataSecondCell(music: music, indexPath: indexpath)
                }
                return cell
            }
        }, titleForHeaderInSection: { dataSource, index in
            let section = dataSource[index]
            return section.title
        })

        viewModel.sectionModelsDriver.drive(tableView.rx.items(dataSource: datasource)).disposed(by: bag)

        tableView.rx.modelSelected(HomeSectionItem.self)
            .asDriver()
            .drive(onNext: { model in
                switch model {
                case .ItemOne(musics: _):
                    self.presentAlert("", message: "Alert multiple section One")
                case .ItemTwo(title: let title, musics: _):
                    self.presentAlert(title, message: "Alert multiple section Two")
                }
            })
            .disposed(by: bag)
    }

    private func presentAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: "\(title) Selected", message: "Message \(message)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
