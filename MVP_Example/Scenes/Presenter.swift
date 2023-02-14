//
//  Presenter.swift
//  MVP_Example
//
//  Created by mobile on 2023/02/13.
//

import UIKit
import RxSwift
import RxCocoa

protocol ReviewListProtocol {
    // View에서 구현할 메소드
    func setUpNaivigationBar()
    func setUpViews()
    func callAPI(_ openWeather: [OpenWeather])
}

final class ReviewListPresenter: NSObject {

    private let viewController: ReviewListProtocol

    private let disposeBag = DisposeBag()

    private let networkService = NetworkService()

    init(viewController: ReviewListProtocol) {
        self.viewController = viewController
    }

    func viewDidLoad() {
        viewController.setUpNaivigationBar()
        viewController.setUpViews()
    }

    func callAPI() {
        networkService.getWeatherInfo(lat: 37.6215, lon: 127.0598)
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .subscribe { event in
            switch event {
            case .next(let (openWeather)):
                self.viewController.callAPI(openWeather)
            case .error(let error):
                print("error: \(error), thread: \(Thread.isMainThread)")
            case .completed:
                print("completed")
            }
        }.disposed(by: disposeBag)
    }
}
