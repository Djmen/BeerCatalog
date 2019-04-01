//
//  BeerService.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import struct RxSwift.Single
import class RxSwift.Observable

enum BeerServiceError: Error {
    case beerNotFound
}

protocol BeerService {
    var favoritesIds: Observable<Set<BeerId>> { get }
    func beers(page: Int, beerName name: String?) -> Single<[Beer]>
    func favoriteBeers() -> Single<[Beer]>
    func randomBeer() -> Single<Beer>
    func addFavoritBeer(with id: BeerId)
    func removeFavoritBeer(with id: BeerId)
}
