//
//  PickerViewController.swift
//  RxSwift_Template
//
//  Created by Phong Huynh N. VN.Danang on 28/12/2022.
//

import UIKit
import RxSwift
import RxCocoa


class PickerViewDelegateProxy: DelegateProxy<UIPickerView, UIPickerViewDelegate>, UIPickerViewDelegate, DelegateProxyType {
    
    weak private(set) var pickerView: UIPickerView?
    
    init(pickerView: UIPickerView) {
        self.pickerView = pickerView
        super.init(parentObject: pickerView, delegateProxy: PickerViewDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        self.register { PickerViewDelegateProxy(pickerView: $0) }
    }
    
    // Getter for delegate proxy
    static func currentDelegate(for object: UIPickerView) -> UIPickerViewDelegate? {
        return object.delegate
    }

    // Setter for delegate proxy
    static func setCurrentDelegate(_ delegate: UIPickerViewDelegate?, to object: UIPickerView) {
        object.delegate = delegate
    }
}

extension Reactive where Base: UIPickerView {

    var delegateProxy: PickerViewDelegateProxy {
        PickerViewDelegateProxy.proxy(for: base)
    }

    public func setDelegateProxy(_ delegate: UIPickerViewDelegate) -> Disposable {
        return PickerViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }

    func castOrThrow<T>(resultType: T.Type, object: Any) throws -> T {
        guard let returnValue = object as? T else {
            throw RxCocoaError.castingError(object: object, targetType: resultType)
        }
        return returnValue
    }
    
    var didSelectRow: ControlEvent<(row: Int, component: Int)> {
        let source = delegateProxy
            .methodInvoked(#selector(UIPickerViewDelegate.pickerView(_:didSelectRow:inComponent:)))
            .map { param in
                return (row: try castOrThrow(resultType: Int.self, object: param[1]) , component: try castOrThrow(resultType: Int.self, object: param[2]))
            }
        return ControlEvent(events: source)
    }
}

class PickerViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Forward Delegate
        pickerView.rx.setDelegateProxy(self).disposed(by: bag)
        pickerView.dataSource = self
        bindingDelegateProxy()
    }
    
    func bindingDelegateProxy() {
        /// Delegate Proxy
        pickerView.rx.didSelectRow.subscribe(onNext: {(row, element) in
            print("Phong--->123")

        }).disposed(by: bag)
    }

}

extension PickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Picker View \(row)"
    }
}

extension PickerViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
}
