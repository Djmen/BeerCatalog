//
//  SettingsStorageImpl.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import Foundation

final class SettingsStorageImpl {
    enum SettingsKey: String {
        case favoritesBeerIds
    }
    
    private let userDefaults = UserDefaults.standard
}

extension SettingsStorageImpl: SettingsStorage {
    var favoritesBeerIds: Set<Int> {
        set {
            userDefaults.set(Array(newValue), forKey: SettingsKey.favoritesBeerIds.rawValue)
            userDefaults.synchronize()
        }
        get {
            let anyArray = userDefaults.array(forKey: SettingsKey.favoritesBeerIds.rawValue) as? [Int]
            guard let set = anyArray.map(Set.init) else {
                return []
            }
            return set
        }
    }
}
