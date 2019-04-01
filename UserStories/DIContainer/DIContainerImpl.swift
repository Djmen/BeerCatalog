//
//  DIContainerImpl.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import Foundation

final class DIContainerImpl: DIContainer {
    lazy var beerService: BeerService = BeerServiceImpl(apiService: ApiServiceImpl(), settings: SettingsStorageImpl())
    lazy var notificationManager: InAppNotificationManager = InAppNotificationManagerImpl()
}
