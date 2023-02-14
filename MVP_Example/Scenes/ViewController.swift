//
//  ViewController.swift
//  MVP_Example
//
//  Created by mobile on 2023/02/13.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ReviewListViewController: UIViewController {
    private lazy var presenter = ReviewListPresenter(viewController: self)
    var latitude = UILabel()
    var longitude = UILabel()
    private var openWeather = BehaviorSubject<[OpenWeather]>(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }
    
    func setUIComponents(_ lat: Double, _ lon: Double) {
        latitude.text = "위도: " + String(lat)
        longitude.text = "경도: " + String(lon)
    }
    
    @objc func didAPICallButtonTapped() {
        presenter.callAPI()
    }
}

extension ReviewListViewController: ReviewListProtocol {
    func setUpNaivigationBar() {
        title = "MVP"
        view.backgroundColor = .systemBackground

        let rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "antenna.radiowaves.left.and.right"), target: self, action: #selector(didAPICallButtonTapped))

        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    func callAPI(_ openWeather: [OpenWeather]) {
        // 방출받은거 출력
        self.openWeather.onNext(openWeather)
        self.setUIComponents((openWeather.first?.lat)!, (openWeather.first?.lon)!)
    }

    func setUpViews() {
        [
            latitude, longitude
        ].forEach {
            view.addSubview($0)
        }

        latitude.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        longitude.snp.makeConstraints { make in
            make.top.equalTo(latitude.snp.bottom).offset(20)
            make.leading.equalTo(latitude.snp.leading)
        }
    }
}

