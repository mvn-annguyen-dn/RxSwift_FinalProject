//
//  HomeViewController.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 03/02/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class HomeViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private var bag: DisposeBag = DisposeBag()
    var viewModel = HomeViewModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        configDataSource()
        getData()
        checkShowErrorCallApi()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabbar()
    }
    
    // MARK: - Private func
    private func configTableView() {
        let slideNib = UINib(nibName: Define.slideCell, bundle: Bundle.main)
        tableView.register(slideNib, forCellReuseIdentifier: Define.slideCell)
        
        let recommendCell = UINib(nibName: Define.recommendCell, bundle: Bundle.main)
        tableView.register(recommendCell, forCellReuseIdentifier: Define.recommendCell)
        
        let popularCell = UINib(nibName: Define.popularCell, bundle: Bundle.main)
        tableView.register(popularCell, forCellReuseIdentifier: Define.popularCell)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: bag)
    }
    
    private func configDataSource() {
        let datasource = RxTableViewSectionedReloadDataSource<HomeSectionModelType>(configureCell: { datasource, tableview, indexpath, item in
            switch datasource[indexpath] {
            case .slider(shop: let sliderShop):
                guard let cell = tableview.dequeueReusableCell(withIdentifier: "SliderCell", for: indexpath) as? SliderCell else { return UITableViewCell() }
                cell.viewModel = self.viewModel.viewModelForSlider(shop: sliderShop)
                cell.selectionStyle = .none
                return cell
            case .recommend(recommendProducts: let recommendProduct):
                guard let cell = tableview.dequeueReusableCell(withIdentifier: "RecommendCell", for: indexpath) as? RecommendCell else { return UITableViewCell() }
                cell.viewModel = self.viewModel.viewModelForRecommend(recommendProduct: recommendProduct)
                cell.selectionStyle = .none
                // Transform Navigation
                cell.rx.didTap.subscribe(onNext: { product in
                    let vc = DetailViewController()
                    vc.viewModel = DetailViewModel(product: product)
                    self.navigationController?.pushViewController(vc, animated: true)
                })
                .disposed(by: cell.bag)
                return cell
            case .popular(popularProducts: let popularProduct):
                guard let cell = tableview.dequeueReusableCell(withIdentifier: "PopularCell", for: indexpath) as? PopularCell else { return UITableViewCell() }
                cell.viewModel = self.viewModel.viewModelForPopular(popularProduct: popularProduct)
                cell.selectionStyle = .none
                // Transform Navigation
                cell.rx.didTap.subscribe(onNext: { product in
                    let vc = DetailViewController()
                    vc.viewModel = DetailViewModel(product: product)
                    self.navigationController?.pushViewController(vc, animated: true)
                })
                .disposed(by: cell.bag)
                return cell
            }
        })
        
        viewModel.sectionModels
            .asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: bag)
    }
    
    private func getData() {
        viewModel.getApiMultiTarget()
    }
    
    private func checkShowErrorCallApi() {
        viewModel.apiErrorMessage
            .bind(to: self.rx.errorMessage)
            .disposed(by: bag)
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return Define.heightSlideCell
        case 1:
            return Define.heightRecommendCell
        case 2:
            return Define.heightPopularCell
        default: return Define.heightDefaultCell
        }
    }
}

// MARK: - Define
extension HomeViewController {
    private struct Define {
        static var slideCell: String = String(describing: SliderCell.self)
        static var recommendCell: String = String(describing: RecommendCell.self)
        static var popularCell: String = String(describing: PopularCell.self)
        static var heightSlideCell: CGFloat = 300
        static var heightRecommendCell: CGFloat = 220
        static var heightPopularCell: CGFloat = 400
        static var heightDefaultCell: CGFloat = 0
    }
}

//extension HomeViewController: RecommendCellDelegate {
//    func cell(cell: RecommendCell, needPerform action: RecommendCell.Action) {
//        switch action {
//        case .didTap(let product):
//            let vc = DetailViewController()
//            vc.viewModel = DetailViewModel(product: product)
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//}

extension Reactive where Base: RecommendCell {
     var delegate : DelegateProxy<RecommendCell, RecommendCellDelegate> {
         return RecommendCellDelegateProxy.proxy(for: base)
     }

     var didTap: Observable<Product> {
         return delegate.methodInvoked(#selector(RecommendCellDelegate.cell(_:product:)))
             .map { parameters in
                 return parameters[1] as? Product ?? Product()
             }
     }
 }

extension Reactive where Base: PopularCell {
     var delegate : DelegateProxy<PopularCell, PopularCellDelegate> {
         return PopularCellDelegateProxy.proxy(for: base)
     }

     var didTap: Observable<Product> {
         return delegate.methodInvoked(#selector(PopularCellDelegate.cell(_:product:)))
             .map { parameters in
                 return parameters[1] as? Product ?? Product()
             }
     }
 }

extension Reactive where Base: BaseViewController {
    var errorMessage: Binder<ApiError> {
        return Binder(self.base) { base, value in
            base.normalAlert(message: value.localizedDescription)
        }
    }
}
