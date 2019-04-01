//
//  ApiErrorDto.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/31/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import Foundation

struct ApiErrorDto: Codable {
    let error: String
    let statusCode: Int
    let message: String
}
