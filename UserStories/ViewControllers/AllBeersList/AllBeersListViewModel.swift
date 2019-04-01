//
//  AllBeersListViewModel.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import RxSwift
import class RxCocoa.BehaviorRelay
import Action

typealias FetchRequest = (page: Int, searchText: String?)

final class AllBeersListViewModel {
    private weak var delegate: AllBeersListDelegate?
    private let beerService: BeerService
    private let notificationManager: InAppNotificationManager
    
    let beers = BehaviorRelay<[Beer]>(value: [])
    var nextPage = 1

    init(delegate: AllBeersListDelegate, beerService: BeerService, notificationManager: InAppNotificationManager) {
        self.delegate = delegate
        self.beerService = beerService
        self.notificationManager = notificationManager
    }
    
    lazy var loadBeers = Action<FetchRequest, Void>() { [weak self] request in
        guard let self = self else { return .just(Void()) }
        return self.beerService.beers(page: request.page, beerName: request.searchText)
            .observeOn(MainScheduler.instance)
            .do(onSuccess: { [weak self] beers in
                guard let self = self else { return }
                if request.page == 1 {
                    self.beers.accept(beers)
                } else if !beers.isEmpty {
                    self.beers.accept(self.beers.value + beers)
                }
                
                guard !beers.isEmpty else { return }
                self.nextPage = request.page + 1
            }, onError: { [weak self] error in
                self?.notificationManager.showError(error)
            })
            .asObservable()
            .map { _ in Void() }
    }

    lazy var onSelectBeer = Action<Beer, Void> () { [weak self] beer in
        self?.delegate?.showDetails(for: beer)
        return .just(Void())
    }
}
