//
//  CarouselCollectionViewCell.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 10/02/2023.
//

import UIKit
import RxSwift

final class CarouselCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var productImageView: UIImageView!
    
    // MARK: - Properties
    var viewModel: CarouselCellViewModel? {
        didSet {
            updateCell()
        }
    }
    var cellBag: DisposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellBag = DisposeBag()
    }
    
    // MARK: - Private methods
    private func updateCell() {
        guard let viewModel = viewModel else { return }
        viewModel.imageSubject
            .compactMap { $0 }
            .flatMap { self.downloadImage(url: $0) }
            .subscribe { [weak self] image in
                guard let this = self else { return }
                this.productImageView.rx
                    .image
                    .onNext(image)
            }
            .disposed(by: cellBag)
    }

    func downloadImage(url: String) -> Observable<UIImage?> {
        return Observable.create { observer in
            guard let url = URL(string: url) else {
                observer.onError(ApiError.badRequest)
                return Disposables.create()
            }
            let urlRequest = URLRequest(url: url)
            URLSession.shared.rx
                .response(request: urlRequest)
                .subscribe(onNext: { data in
                    let image = UIImage(data: data.data)
                    observer.onNext(image)
                }, onError: { _ in
                    observer.onError(ApiError.noData)
                }, onCompleted: {
                    print("onCompleted")
                }).disposed(by: self.cellBag)
            return Disposables.create()
        }
        .subscribe(on: MainScheduler.instance)
    }
}
