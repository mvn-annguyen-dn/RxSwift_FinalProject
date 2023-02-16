//
//  SearchViewController.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 07/02/2023.
//

import UIKit
import RxSwift
import RxDataSources

final class SearchViewController: BaseViewController {
    
    // MARK: - Outles
    @IBOutlet private weak var searchCollectionView: UICollectionView!
    
    // MARK: - Properties
    private let searchController = UISearchController(searchResultsController: nil)
    private let disposeBag: DisposeBag = DisposeBag()
    var viewModel: SearchViewModel?
    
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigation()
        configCollectionView()
        configSearchController()
        configDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStateSearch()
    }
    
    // MARK: - Private methods
    private func configNavigation() {
        navigationItem.rx
            .title
            .onNext(Define.title)
    }
    
    private func configCollectionView() {
        let searchNib = UINib(nibName: Define.cellName, bundle: Bundle.main)
        searchCollectionView.register(searchNib, forCellWithReuseIdentifier: Define.cellName)
        searchCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        searchCollectionView.rx
            .keyboardDismissMode
            .onNext(.onDrag)
    }
    
    private func configDataSource() {
        guard let viewModel = viewModel else { return }
        viewModel.searchProducts
            .bind(to: searchCollectionView.rx.items) { [weak self] (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                guard  let this = self,
                       let cell = this.searchCollectionView.dequeueReusableCell(withReuseIdentifier: Define.cellName, for: indexPath) as? SearchCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.viewModel = viewModel.viewModelForItem(at: indexPath)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func configSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.rx.setDelegate(self).disposed(by: disposeBag)
        searchController.searchBar.rx
            .returnKeyType
            .onNext(.done)
        searchController.searchBar.rx
            .scopeButtonTitles
            .onNext(["Product", "Shop"])
        searchController.searchBar.rx
            .placeholder
            .onNext("Searching...")
        navigationItem.rx
            .searchController
            .onNext(searchController)
    }
    
    private func updateStateSearch() {
        tabBarController?.tabBar.rx
            .isHidden
            .onNext(false)
        navigationController?.rx
            .isNavigationBarHidden
            .onNext(false)
        searchController.rx
            .isActive
            .onNext(true)
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
}

// MARK: - DelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 15, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Define.insetSection
    }
}

// MARK: - Define
extension SearchViewController {
    private struct Define {
        static var title: String = "Search"
        static var cellName: String = String(describing: SearchCollectionViewCell.self)
        static var insetSection = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let viewModel = viewModel,
              let searchText = searchController.searchBar.text else { return }
        let scopeButton = searchController.searchBar.scopeButtonTitles?[searchController.searchBar.selectedScopeButtonIndex]
        if !searchText.isEmpty {
            viewModel.searching = true
            viewModel.searchProducts.accept([])
            if scopeButton == "Product" {
                let products = viewModel.products.value.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
                viewModel.searchProducts
                    .accept(products)
            } else {
                let products = viewModel.products.value.filter { $0.content?.lowercased().contains(searchText.lowercased()) ?? false }
                viewModel.searchProducts
                    .accept(products)
            }
        } else {
            if viewModel.scopeButtonPress {
                let scopeButton = searchController.searchBar.scopeButtonTitles?[searchController.searchBar.selectedScopeButtonIndex]
                if !(scopeButton?.isEmpty ?? false) {
                    viewModel.searchProducts.accept([])
                }
                viewModel.searching = false
            } else {
                viewModel.searching = false
                viewModel.searchProducts.accept([])
            }
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let viewModel = viewModel else { return }
        viewModel.searching = false
        viewModel.searchProducts.accept([])
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let viewModel = viewModel else { return }
        viewModel.scopeButtonPress = true
        let scopeButton = searchController.searchBar.scopeButtonTitles?[searchController.searchBar.selectedScopeButtonIndex]
        if !(scopeButton?.isEmpty ?? false) {
            viewModel.searchProducts.accept(viewModel.products.value)
        } else { }
    }

}
