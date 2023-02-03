//
//  ExampleViewController.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 02/02/2023.
//

import UIKit
import RxCocoa
import RxSwift

class ExampleViewController: BaseViewController {

    @IBOutlet weak var tapButton: UIButton!
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func getApiExam() -> Single<FeedResults> {
        return ApiNetWorkManager.shared.request(FeedResults.self, .target(LoginTarget.example))
    }

    @IBAction func tapButtonTouchUpInside(_ sender: Any) {
        getApiExam()
            .subscribe(onSuccess: { res in
                print("AAA", res.results ?? [])
            }, onFailure: { error in
                let apiError = error as? ApiError ?? .unknown
                self.normalAlert(message: apiError.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
