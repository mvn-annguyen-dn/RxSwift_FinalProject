//
//  MovieTableViewCell.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 20/12/2022.
//

import UIKit
import RxSwift

final class MovieTableViewCell: UITableViewCell {

    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var movieOverviewLabel: UILabel!

    var viewModel: MovieCellViewModel? {
        didSet {
            updateCell()
        }
    }
    var disposedBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func updateCell() {
        guard let viewModel = viewModel else { return }
        viewModel.movieSub
            .map { $0?.title }
            .bind(to: movieNameLabel.rx.text)
            .disposed(by: disposedBag)

        viewModel.movieSub
            .map { $0?.overview }
            .bind(to: movieOverviewLabel.rx.text)
            .disposed(by: disposedBag)

        viewModel.movieSub
            .map { ($0?.posterPath) ?? "" }
            .flatMap { self.downloadImage(url: "http://image.tmdb.org/t/p/w500\($0)") }
            .subscribe { [weak self] image in
                guard let this = self else { return }
                this.movieImageView.rx
                    .image
                    .onNext(image)
            }
            .disposed(by: disposedBag)
    }
    
    private func downloadImage(url: String) -> Observable<UIImage?> {
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, _ in
                guard let data = data else {
                    observer.onNext(nil)
                    observer.onCompleted()
                    return
                }
                let image = UIImage(data: data)
                observer.onNext(image)
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create() {
                task.cancel()
            }
        }
        .observe(on: MainScheduler.instance)
    }
}
