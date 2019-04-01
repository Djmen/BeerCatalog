//
//  FavoritesViewModel.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import class RxCocoa.BehaviorRelay
import RxSwift
import Action

final class FavoritesViewModel {
    private weak var delegate: FavoritesDelegate?
    private let beerService: BeerService
    private let notificationManager: InAppNotificationManager
    private let disposeBag = DisposeBag()
    
    let favoritesBeers = BehaviorRelay<[Beer]>(value: [])

    lazy var fetchFavorites = CocoaAction() { [weak self] _ in
        guard let self = self else { return .just(Void()) }
        
        return self.beerService.favoriteBeers()
            .observeOn(MainScheduler.instance)
            .do(onSuccess: { [weak self] beers in
                guard let self = self else { return }
                
                self.favoritesBeers.accept(beers)
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
    
    lazy var removeFromFavorites = Action<BeerId, Void> { [weak self] beerId in
        guard let self = self else { return .just(Void()) }
        
        return .just(self.beerService.removeFavoritBeer(with: beerId))
    }

    init(delegate: FavoritesDelegate, beerService: BeerService, notificationManager: InAppNotificationManager) {
        self.delegate = delegate
        self.beerService = beerService
        self.notificationManager = notificationManager
        
        setupBinding()
    }

    private func setupBinding() {
        beerService.favoritesIds.distinctUntilChanged()
            .map { _ in Void() }
            .bind(to: fetchFavorites.inputs)
            .disposed(by: disposeBag)
    }
}
