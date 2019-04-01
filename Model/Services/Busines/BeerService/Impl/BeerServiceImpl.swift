//
//  BeerServiceImpl.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import Foundation
import struct RxSwift.Single
import class RxSwift.Observable
import class RxCocoa.BehaviorRelay

final class BeerServiceImpl {
    
    let apiService: ApiService
    let settings: SettingsStorage
    private lazy var favoritesIdsRelay = BehaviorRelay<Set<BeerId>>(value: settings.favoritesBeerIds)

    init(apiService: ApiService, settings: SettingsStorage) {
        self.apiService = apiService
        self.settings = settings
    }
}

extension BeerServiceImpl: BeerService {
    var favoritesIds: Observable<Set<BeerId>> {
        return favoritesIdsRelay.asObservable()
    }
    
    func beers(page: Int, beerName name: String?) -> Single<[Beer]> {
        return apiService.fetchBeers(page: page, beerName: name)
            .map { dto -> [Beer] in dto }
    }

    func randomBeer() -> Single<Beer> {
        return apiService.fetchRandomBeer()
            .map { dto -> Beer in
                guard let first = dto.first else { throw BeerServiceError.beerNotFound }
                return first
            }
    }
    
    func favoriteBeers() -> Single<[Beer]> {
        guard !favoritesIdsRelay.value.isEmpty else { return .just([]) }
        
        return apiService.fetchBeers(ids: favoritesIdsRelay.value)
            .map { dto -> [Beer] in dto }
    }

    func addFavoritBeer(with id: BeerId) {
        let newValue = settings.favoritesBeerIds.union([id])
        settings.favoritesBeerIds = newValue
        favoritesIdsRelay.accept(newValue)
    }

    func removeFavoritBeer(with id: BeerId) {
        let newValue = settings.favoritesBeerIds.subtracting([id])
        settings.favoritesBeerIds = newValue
        favoritesIdsRelay.accept(newValue)
    }
}

extension BeerDto: Beer {
    var imageURL: URL? {
        return imageUrl.flatMap { URL(string: $0) }
    }
}
