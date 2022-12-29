//
//  TableViewController.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 28/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

///Created Delegate Proxy
class TableViewDelegateProxy: DelegateProxy<UITableView, UITableViewDelegate>, UITableViewDelegate, DelegateProxyType {
    
    weak private(set) var tableView: UITableView?
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init(parentObject: tableView, delegateProxy: TableViewDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { TableViewDelegateProxy(tableView: $0) }
    }
    
    static func currentDelegate(for object: UITableView) -> UITableViewDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: UITableViewDelegate?, to object: UITableView) {
        object.delegate = delegate
    }
}

extension Reactive where Base: UITableView {
    
    var delegateProxy: TableViewDelegateProxy {
        TableViewDelegateProxy.proxy(for: base)
    }
    
    func castOrThrow<T>(resultType: T.Type, object: Any) throws -> T {
        guard let returnValue = object as? T else {
            throw RxCocoaError.castingError(object: object, targetType: resultType)
        }
        return returnValue
    }
    
    var didSelectRowAt: ControlEvent<IndexPath> {
        let source = delegateProxy.methodInvoked(#selector(UITableViewDelegate.tableView(_:didSelectRowAt:)))
            .map { param in
                return try castOrThrow(resultType: IndexPath.self, object: param[1])
            }
        
        return ControlEvent(events: source)
    }
    
    var didDeselectRowAt: ControlEvent<IndexPath> {
        let source = delegateProxy.methodInvoked(#selector(UITableViewDelegate.tableView(_:didDeselectRowAt:)))
            .map { param in
                return try castOrThrow(resultType: IndexPath.self, object: param[1])
            }
        
        return ControlEvent(events: source)
    }
}

class TableViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var bag = DisposeBag()
    private var cities = ["Hà Nội","Hải Phòng", "Vinh", "Huế", "Đà Nẵng", "Nha Trang", "Đà Lạt", "Vũng Tàu", "Hồ Chí Minh"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
    }
    
    private func configTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        Observable.of(cities)
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (index, element, cell) in
                cell.textLabel?.text = element
            }
            .disposed(by: bag)
        
        /// Delegate Proxy
        tableView.rx.didSelectRowAt.subscribe(onNext: { _ in
            print("Phong--->didSelectRowAt")
        })
        .disposed(by: bag)
        
        tableView.rx.didDeselectRowAt.subscribe(onNext: {_ in
            print("Phong--->didDeselectRowAt")
        })
        .disposed(by: bag)
    }
}
