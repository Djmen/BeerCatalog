//
//  Beer.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import Foundation

typealias BeerId = Int

protocol Beer {
    var id: BeerId { get }
    var name: String { get }
    var tagline: String { get }
    var description: String { get }
    var imageURL: URL? { get }
}
