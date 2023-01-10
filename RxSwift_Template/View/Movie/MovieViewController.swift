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

final class MovieViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let diposeBag: DisposeBag = DisposeBag()

    var viewModel: MovieViewModel = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
//        viewModel.getMusicData()
        viewModel.zipMovieData()
        configDataSource()
    }

    private func configTableView() {
        let titledNib = UINib(nibName: Define.titledCell, bundle: .main)
        tableView.register(titledNib, forCellReuseIdentifier: Define.titledCell)
        let nonTitleNib = UINib(nibName: Define.nonTitleCell, bundle: .main)
        tableView.register(nonTitleNib, forCellReuseIdentifier: Define.nonTitleCell)
        tableView.rx.setDelegate(self).disposed(by: diposeBag)
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

//        tableView.rx.modelSelected(SectionItem.self)
//            .subscribe(onNext: { element in
//                switch element {
//                case .titled(item: let item):
//                    print("Titled:", item.title ?? "")
//                case .nonTilte(item: let item):
//                    print("NonTitle:", item.title ?? "HEHE")
//                }
//            })
//            .disposed(by: diposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                switch self.viewModel.musicRelay.value[indexPath.section].items[indexPath.row] {
                case .titled(item: let movie):
                    print("Titled:", movie.title ?? "")
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
