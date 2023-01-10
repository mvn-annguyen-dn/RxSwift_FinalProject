//
//  MusicViewController.swift
//  RxSwift_Template
//
//  Created by Luong Tran M. VN.Danang on 05/01/2023.
//

import UIKit

final class MusicViewController: UIViewController {

    var viewModel: MovieViewModel = MovieViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getMusicData()
    }
}
