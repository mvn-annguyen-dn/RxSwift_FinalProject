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
            .asDriver(onErrorJustReturn: true)
            .drive(activityIndicatorView.rx.isHidden)
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
//                cell.rx.didTap
//                    .subscribe { [weak self] _ in
//                        guard let this = self else { return }
//                        this.deleteItems(indexPath: indexPath)
//                    }
//                    .disposed(by: cell.disposedBag)
                cell.rx.setDelegate(this).disposed(by: cell.disposedBag)
                cell.viewModel = this.viewModel.viewModelForItem(element: element)
                return cell
            }
            .disposed(by: disposeBag)
        tableView.rx
            .modelSelected(Movie.self)
            .map(\.title)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
    }

    private func deleteItems(indexPath: IndexPath) {
        let itemDeleted = BehaviorSubject(value: indexPath)
        itemDeleted.withLatestFrom(viewModel.movies, resultSelector: { ($0, $1) })
            .map {
                var (indexPath, movies) = $0
                movies.remove(at: indexPath.row)
                self.tableView.reloadRows(at: [indexPath], with: .left)
                return movies
            }
            .bind(to: viewModel.movies)
            .disposed(by: disposeBag)
    }

    private func configSearchBar() {
        searchBar.rx.text
            .distinctUntilChanged()
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] query in
                guard let this = self,
                      let query = query else { return }
                this.viewModel.searchData(query)
            })
            .disposed(by: disposeBag)
    }
}

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension Reactive where Base: UITableViewCell {
    var setSelected: Observable<(selected: Bool, animated: Bool)> {
        base.rx.methodInvoked(#selector(UITableViewCell.setSelected(_:animated:)))
            .map { (selected: $0[0] as? Bool ?? false, animated: $0[1] as? Bool ?? false) }
    }
}

extension MovieViewController: MovieCellDelegate {
    func cell(_ cell: MovieTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.movies
            .subscribe { movies in
                print("Movie: ", movies[indexPath.row].title ?? "")
            }
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: MovieTableViewCell {
    func setDelegate(_ delegate: MovieCellDelegate) -> Disposable {
        return RxMKMovieCellDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }
}

extension MovieTableViewCell: HasDelegate {
    public typealias Delegate = MovieCellDelegate
}

class RxMKMovieCellDelegateProxy: DelegateProxy<MovieTableViewCell, MovieCellDelegate>, DelegateProxyType, MovieCellDelegate {
    weak public private(set) var movieCell: MovieTableViewCell?
    
    public init(movieCell: ParentObject) {
        self.movieCell = movieCell
        super.init(parentObject: movieCell, delegateProxy: RxMKMovieCellDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxMKMovieCellDelegateProxy(movieCell: $0) }
    }
}
