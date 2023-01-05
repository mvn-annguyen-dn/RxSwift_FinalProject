//
//  OneCellViewController.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 03/01/2023.
//

import UIKit
import RxSwift
import RxDataSources

final class OneCellViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    var viewModel: OneCellViewModel = OneCellViewModel()
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "One Section"
        configTableView()
        configDataSource()
    }

    private func configTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell1")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell2")
        
    }

    private func configDataSource() {
//        viewModel.dataRelay
//            .bind(to: tableView.rx.items) { tableView, index, element in
//                let indexPath = IndexPath(row: index, section: 0)
//                let cell = tableView.dequeueReusableCell(withIdentifier: "CellName", for: indexPath)
//                cell.textLabel?.text = element.name
//                cell.selectionStyle = .none
//                return cell
//            }
//            .disposed(by: disposeBag)
        
        viewModel.dataRelay2
            .bind(to: tableView.rx.items) { [weak self]  (_, index, element) -> UITableViewCell in
                guard let this = self else { return UITableViewCell() }
                let indexPath = IndexPath(row: index, section: 0)
                switch element {
                case .name(let name):
                    let cell = this.tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath)
                    cell.textLabel?.text = name.name
                    cell.backgroundColor = .cyan
                    cell.selectionStyle = .none
                    return cell
                case .image(let image):
                    let cell = this.tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
                    cell.imageView?.image = UIImage(named: image.image)
                    cell.selectionStyle = .none
                    return cell
                }
            }
            .disposed(by: disposeBag)
    }
}
