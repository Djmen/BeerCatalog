//
//  ApiService.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import struct RxSwift.Single

protocol ApiService {
    func fetchBeers(page: Int, beerName name: String?) -> Single<[BeerDto]>
    func fetchRandomBeer() -> Single<[BeerDto]>
    func fetchBeers(ids: Set<Int>) -> Single<[BeerDto]>
}
