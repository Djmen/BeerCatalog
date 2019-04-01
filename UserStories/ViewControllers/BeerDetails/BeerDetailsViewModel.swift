//
//  BeerDetailsViewModel.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import RxSwift
import class RxCocoa.BehaviorRelay
import Action

final class BeerDetailsViewModel {
    enum DetailsType {
        case random
        case particular(Beer)
    }
    private weak var delegate: BeerDetailsDelegate?
    private let beerService: BeerService
    private let notificationManager: InAppNotificationManager
    let type: DetailsType
    var beer = BehaviorRelay<Beer?>(value: nil)
    lazy var isFavorite = Observable.combineLatest(beer.filter { $0 != nil },
                                                   beerService.favoritesIds) { beer, ids in
        ids.contains(beer!.id)
    }
    
    lazy var loadRandomBeer = CocoaAction() { [weak self] _ in
        guard let self = self else { return .just(Void()) }
        
        return self.beerService.randomBeer()
                .observeOn(MainScheduler.instance)
                .do(onSuccess: { [weak self] beer in
                    guard let self = self else { return }

                    self.beer.accept(beer)
                }, onError: { [weak self] error in
                    self?.notificationManager.showError(error)
                })
                .asObservable()
                .map { _ in Void() }
    }

    lazy var addToFavorites = CocoaAction() { [weak self] _ in
        guard let self = self, let beerId = self.beer.value?.id else { return .just(Void()) }
        
        return .just(self.beerService.addFavoritBeer(with: beerId))
    }

    lazy var removeFromFavorites = CocoaAction() { [weak self] _ in
        guard let self = self, let beerId = self.beer.value?.id else { return .just(Void()) }
        
        return .just(self.beerService.removeFavoritBeer(with: beerId))
    }

    init(delegate: BeerDetailsDelegate, type: DetailsType, beerService: BeerService, notificationManager: InAppNotificationManager) {
        self.delegate = delegate
        self.type = type
        self.beerService = beerService
        self.notificationManager = notificationManager
    
        initialSetup()
    }
    
    private func initialSetup() {
        switch type {
        case .random:
            loadRandomBeer.execute(Void())
        case .particular(let beer):
            self.beer.accept(beer)
        }
    }
}
