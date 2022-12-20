//
//  MovieViewController.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 20/12/2022.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import AVKit
import WebKit

final class MovieViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    var disposeBag = DisposeBag()
    var viewModel: MovieViewModel = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configSearchBar()
        viewModel.loadingData
            .bind(to: activityIndicatorView.rx.isHidden)
            .disposed(by: disposeBag)
    }

    private func configTableView() {
        let nib = UINib(nibName: String(describing: MovieTableViewCell.self), bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "MovieCell")
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.movies
            .bind(to: tableView.rx.items) { [weak self] tableView, index, element in
                let indexPath = IndexPath(row: index, section: 0)
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell,
                      let this = self else {
                    return UITableViewCell()
                }
                cell.selectionStyle = .none
                cell.rx.setSelected
                    .subscribe(onNext: { [contentView = cell.contentView] selected, animated in
                        contentView.backgroundColor = selected ? .cyan : .white
                        contentView.layer.cornerRadius = 10
                    })
                    .disposed(by: cell.disposedBag)
                cell.viewModel = this.viewModel.viewModelForItem(element: element)
                return cell
            }
            .disposed(by: disposeBag)
        tableView.rx
            .modelSelected(Movie.self)
            .subscribe(onNext: { model in
                self.navigationItem.rx.title.onNext(model.title)
//                self.test(id: model.id ?? 0)
            })
            .disposed(by: disposeBag)
    }

    private func test(id: Int) {
//        let vc = VideoViewController()
//        vc.viewModel = VideoViewModel(id: id)
//        present(vc, animated: true)
    }

    private func configSearchBar() {
        searchBar.rx.setDelegate(self)
            .disposed(by: disposeBag)
        searchBar.rx.text
            .throttle(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] query in
                guard let this = self,
                      let query = query else { return }
                query.isEmpty ? this.getData() : this.searchData(query)
            })
            .disposed(by: disposeBag)
    }
}

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension MovieViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
}

extension MovieViewController {
    private func getData() {
        viewModel.loadingData.onNext(false)
        viewModel.getMovies()
            .subscribe { [weak self] data in
                guard let this = self else { return }
                this.viewModel.loadingData.onNext(true)
                this.viewModel.movies.onNext(data.results ?? [])
            }
            .disposed(by: disposeBag)
    }

    private func searchData(_ query: String) {
        let searchText = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        viewModel.loadingData.onNext(false)
        viewModel.searchMovies(searchText ?? "")
            .subscribe { [weak self] data in
                guard let this = self else { return }
                this.viewModel.loadingData.onNext(true)
                this.viewModel.movies.onNext(data.results ?? [])
            }
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: UITableViewCell {
    var setSelected: Observable<(selected: Bool, animated: Bool)> {
        base.rx.methodInvoked(#selector(UITableViewCell.setSelected(_:animated:)))
            .map { (selected: $0[0] as! Bool, animated: $0[1] as! Bool) }
    }
}
