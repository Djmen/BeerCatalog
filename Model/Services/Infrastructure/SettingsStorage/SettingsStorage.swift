//
//  SettingsStorage.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import Foundation

protocol SettingsStorage: class {
    var favoritesBeerIds: Set<Int> { get set }
}
