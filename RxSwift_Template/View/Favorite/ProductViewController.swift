//
//  ProductViewController.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 17/01/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class ProductViewController: UIViewController {

    @IBOutlet private weak var activitiIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!

    var viewModel: ProductViewModel = ProductViewModel()
    private let disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        showLoading()
        viewModel.getDataProduct()
        configDataSouce()
    }

    private func configTableView() {
        let nib = UINib(nibName: Define.productCell, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: Define.productCell)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    private func configDataSouce() {
        viewModel.productRelay
            .bind(to: tableView.rx.items)({ [weak self] (tv, index, element) in
                let indexPath = IndexPath(row: index, section: 0)
                guard let this = self,
                      let cell = this.tableView.dequeueReusableCell(withIdentifier: Define.productCell, for: indexPath) as? ProductTableViewCell else {
                    return UITableViewCell()
                }
                cell.selectionStyle = .none
                cell.viewModel = this.viewModel.viewModelForItem(at: element)
                return cell
            })
            .disposed(by: disposeBag)
    }

    private func showLoading() {
        viewModel
            .isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(activitiIndicator.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

extension ProductViewController {
    private struct Define {
        static var productCell: String = String(describing: ProductTableViewCell.self)
    }
}

extension ProductViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.viewModel = viewModel.viewModelForDetail(at: indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }
}
