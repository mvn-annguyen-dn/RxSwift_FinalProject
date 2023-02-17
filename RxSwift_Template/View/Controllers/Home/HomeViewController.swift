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
    }
    
    // MARK: - Private func
    private func configTableView() {
        let slideNib = UINib(nibName: Define.slideCell, bundle: Bundle.main)
        tableView.register(slideNib, forCellReuseIdentifier: Define.slideCell)
        
        let recommendCell = UINib(nibName: Define.recommendCell, bundle: Bundle.main)
        tableView.register(recommendCell, forCellReuseIdentifier: Define.recommendCell)
        
        let popularCell = UINib(nibName: Define.popularCell, bundle: Bundle.main)
        tableView.register(popularCell, forCellReuseIdentifier: Define.popularCell)
        
        tableView.rx.setDelegate(self).disposed(by: bag)
    }
    
    private func configDataSource() {
        let datasource = RxTableViewSectionedReloadDataSource<HomeSectionModelType>(configureCell: { datasource, tableview, indexpath, item in
            switch datasource[indexpath] {
            case .slider:
                guard let cell = tableview.dequeueReusableCell(withIdentifier: "SliderCell", for: indexpath) as? SliderCell else { return UITableViewCell() }
                cell.viewModel = self.viewModel.viewModelForSlider(indexPath: indexpath)
                cell.selectionStyle = .none
                return cell
            case .recommend:
                guard let cell = tableview.dequeueReusableCell(withIdentifier: "RecommendCell", for: indexpath) as? RecommendCell else { return UITableViewCell() }
                cell.viewModel = self.viewModel.viewModelForRecommend(indexPath: indexpath)
                cell.selectionStyle = .none
                return cell
            case .popular:
                guard let cell = tableview.dequeueReusableCell(withIdentifier: "PopularCell", for: indexpath) as? PopularCell else { return UITableViewCell() }
                cell.viewModel = self.viewModel.viewModelForPopular(indexPath: indexpath)
                cell.selectionStyle = .none
                return cell
            }
        })
        
        viewModel.sectionModels.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: bag)
    }
    
    private func getData() {
        viewModel.getApiMultiTarget()
        viewModel.errorBehaviorRelay.subscribe(onNext: { error in
            self.normalAlert(message: error.localizedDescription)
        })
        .disposed(by: bag)
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 300
        case 1:
            return 220
        case 2:
            return 400
        default: return 0
        }
    }
}

// MARK: - Define
extension HomeViewController {
    private struct Define {
        static var slideCell: String = String(describing: SliderCell.self)
        static var recommendCell: String = String(describing: RecommendCell.self)
        static var popularCell: String = String(describing: PopularCell.self)
    }
}
