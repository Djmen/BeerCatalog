//
//  ApiServiceImpl.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import struct RxSwift.Single

final class ApiServiceImpl {
    private let requestBuilder = RequestBuilder()
    private let requestExecutor = RequestExecutor()
}

extension ApiServiceImpl: ApiService {
    func fetchBeers(page: Int, beerName name: String?) -> Single<[BeerDto]> {
        return requestExecutor.executeRequest(requestBuilder.beers(page: page, name: name))
    }

    func fetchBeers(ids: Set<Int>) -> Single<[BeerDto]> {
        return requestExecutor.executeRequest(requestBuilder.beers(ids: ids))
    }
    
    func fetchRandomBeer() -> Single<[BeerDto]> {
        return requestExecutor.executeRequest(requestBuilder.randomBeer())
    }
}
