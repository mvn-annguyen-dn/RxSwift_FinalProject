//
//  MovieViewController.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 06/01/2023.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Combine

final class MovieViewController: UIViewController {

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!

    private let diposeBag: DisposeBag = DisposeBag()

    var viewModel: MovieViewModel = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        viewModel.zipMovieData()
        viewModel.isLoading
            .asDriver(onErrorJustReturn: true)
            .drive(activityIndicatorView.rx.isHidden)
            .disposed(by: diposeBag)
        viewModel.error
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] error in
                guard let this = self else { return }
//                this.showAlert(title: "WARNING", message: error).subscribe { _ in
//                    exit(0)
//                }
//                .disposed(by: this.diposeBag)
                this.rx.showError.onNext(error)
            })
            .disposed(by: diposeBag)
        configDataSource()
    }

    private func configTableView() {
        let titledNib = UINib(nibName: Define.titledCell, bundle: .main)
        tableView.register(titledNib, forCellReuseIdentifier: Define.titledCell)
        let nonTitleNib = UINib(nibName: Define.nonTitleCell, bundle: .main)
        tableView.register(nonTitleNib, forCellReuseIdentifier: Define.nonTitleCell)
        tableView.rx.setDelegate(self).disposed(by: diposeBag)
        tableView.decelerationRate =  .fast
    }

    private func configDataSource() {
        let dataSource = RxTableViewSectionedReloadDataSource<MySectionModel>(
            configureCell: { [weak self] dataSource, _, indexPath, _ in
                switch dataSource[indexPath] {
                case .titled(item: let item):
                    guard let this = self,
                          let cell = this.tableView.dequeueReusableCell(withIdentifier: Define.titledCell, for: indexPath) as? TitledTableViewCell
                          else {
                        return UITableViewCell()
                    }
                    cell.selectionStyle = .none
                    cell.viewModel = this.viewModel.viewModelForTrending(at: item)
                    return cell
                case .nonTilte(item: let item):
                    guard let this = self,
                          let cell = this.tableView.dequeueReusableCell(withIdentifier: Define.nonTitleCell, for: indexPath) as? NonTitleTableViewCell
                          else {
                        return UITableViewCell()
                    }
                    cell.selectionStyle = .none
                    cell.viewModel = this.viewModel.viewModelForUpcoming(at: item)
                    return cell
                }
            }
        )
        
        dataSource.titleForHeaderInSection = { theDataSource, index in
            return theDataSource.sectionModels[index].header.type
        }
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                switch self.viewModel
                    .musicRelay
                    .value[indexPath.section].items[indexPath.row] {
                case .titled(item: let movie):
                    print("Titled:", movie.title ?? "", indexPath)
                case .nonTilte(item: let movie):
                    print("NonTitle:", movie.title ?? "AA")
                }
            })
            .disposed(by: diposeBag)
        
        viewModel
            .musicRelay
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: diposeBag)
    }
}

extension MovieViewController {
    private struct Define {
        static var titledCell: String = String(describing: TitledTableViewCell.self)
        static var nonTitleCell: String = String(describing: NonTitleTableViewCell.self)
    }
}

extension MovieViewController: UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}


extension UIViewController {
    public func showAlert(title: String, message: String) -> Completable {
        return Completable.create { observer in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: { _ in
                observer(.completed)
            })
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                observer(.completed)
            }
            alert.addAction(okButton)
            alert.addAction(cancelButton)
            self.present(alert, animated: true)
            return Disposables.create()
        }
    }

    public func showError(message: String) {
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}

extension Reactive where Base: UIViewController {
    var showError: Binder<String> {
        return Binder(base) { vc, erorr in
            vc.showError(message: erorr)
        }
    }
}
