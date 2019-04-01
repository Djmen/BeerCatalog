//
//  RequestBuilder.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import Foundation

final class RequestBuilder {
    private let endpoint = "https://api.punkapi.com"
    
    func beers(page: Int, name: String?) -> URLRequest? {
        var urlComponents = requestUrl(path: "/v2/beers")
        var params = [URLQueryItem(name: "page", value: String(page))]
        if let name = name, !name.isEmpty {
            params.append(URLQueryItem(name: "beer_name", value: name))
        }
        urlComponents.queryItems = params

        return urlComponents.url.map{ URLRequest(url: $0) }
    }

    func beers(ids: Set<Int>) -> URLRequest? {
        var urlComponents = requestUrl(path: "/v2/beers")
        let ids = ids.map(String.init).sorted().joined(separator: "|")
        urlComponents.queryItems = [URLQueryItem(name: "ids", value: ids)]
        
        return urlComponents.url.map{ URLRequest(url: $0) }
    }
    
    func randomBeer() -> URLRequest? {
        let urlComponents = requestUrl(path: "/v2/beers/random")

        return urlComponents.url.map { URLRequest(url: $0) }
    }
    
    private func requestUrl(path: String) -> URLComponents {
        guard var components = URLComponents(string: endpoint) else { fatalError("Invalid Api endpoint")}
        components.path = path
        return components
    }
}
