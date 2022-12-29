//
//  MovieTableViewCell.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 20/12/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

//@objc
//protocol MovieCellDelegate {
//    @objc optional func cell(
//        _ cell: MovieTableViewCell,
//        needPerform action: MovieTableViewCell.Action
//    ) -> Void
//}

//final class MovieCellDelegateProxy:
//    DelegateProxy<MovieTableViewCell, MovieCellDelegate>,
//    DelegateProxyType,
//    MovieCellDelegate {
//
//    static func registerKnownImplementations() {
//        self.register { parent in
//            MovieCellDelegateProxy(parentObject: parent, delegateProxy: self)
//        }
//    }
//
//    static func currentDelegate(for object: MovieTableViewCell) -> MovieCellDelegate? {
//        return object.delegate
//    }
//
//    static func setCurrentDelegate(_ delegate: MovieCellDelegate?, to object: MovieTableViewCell) {
//        object.delegate = delegate
//    }
//}

@objc
protocol MovieCellDelegate : NSObjectProtocol {
    @objc optional func cell(_ cell: MovieTableViewCell)
}

final class MovieTableViewCell: UITableViewCell {
    
    @objc enum Action: Int {
        case didTap
    }

    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var movieOverviewLabel: UILabel!

    var viewModel: MovieCellViewModel? {
        didSet {
            updateCell()
        }
    }
    var disposedBag = DisposeBag()
    
    weak var delegate: MovieCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposedBag = DisposeBag()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        movieImageView.isUserInteractionEnabled = true
        movieImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard let viewModel = viewModel else { return }
        let movie = viewModel.movieSub.compactMap { $0 }
        movie
            .map(\.title)
            .subscribe { [weak self] element in
                guard let this = self else { return }
                this.delegate?.cell?(this)
            }
            .disposed(by: disposedBag)
    }

    private func updateCell() {
        guard let viewModel = viewModel else { return }
        let movie = viewModel.movieSub.compactMap { $0 }
        
        movie
            .map(\.title)
            .bind(to: movieNameLabel.rx.text)
            .disposed(by: disposedBag)

        movie
            .map(\.overview)
            .bind(to: movieOverviewLabel.rx.text)
            .disposed(by: disposedBag)
        
        movie
            .map(\.posterPath)
            .flatMap { self.downloadImage(url: "https://image.tmdb.org/t/p/w500\($0 ?? "")") }
            .subscribe { [weak self] image in
                guard let this = self else { return }
                this.movieImageView.rx
                    .image
                    .onNext(image)
            }
            .disposed(by: disposedBag)
    }

    // Using URLSession with RxSwift
    private func downloadImage(url: String) -> Observable<UIImage?> {
        return Observable.create { observer in
            guard let url = URL(string: url) else {
                observer.onError(APIError.pathError)
                return Disposables.create()
            }
            let urlRequest = URLRequest(url: url)
            URLSession.shared.rx
                .response(request: urlRequest)
                .subscribe(onNext: { data in
                    let image = UIImage(data: data.data)
                    observer.onNext(image)
                }, onError: { _ in
                    observer.onError(ApiError.error("Download Error"))
                }, onCompleted: {
                    print("onCompleted")
                }).disposed(by: self.disposedBag)
            return Disposables.create()
        }
        .subscribe(on: MainScheduler.instance)
    }
    
    // Using URLSession with Swift
    /*
    private func downloadImage(url: String) -> Observable<UIImage?> {
        return Observable.create { observer in
            guard let url = URL(string: url) else {
                observer.onError(APIError.pathError)
                return Disposables.create()
            }
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else {
                    observer.onError(ApiError.error("Fail data"))
                    return
                }
                let image = UIImage(data: data)
                if let image = image {
                    observer.onNext(image)
                } else {
                    observer.onNext(nil)
                }
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create() {
                task.cancel()
            }
        }
        .observe(on: MainScheduler.instance)
    }
    */
}
