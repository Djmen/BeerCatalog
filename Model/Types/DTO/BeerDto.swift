//
//  BeerDto.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import Foundation

struct BeerDto: Codable {
    let id: Int
    let name: String
    let tagline: String
    let description: String
    let imageUrl: String?
}
