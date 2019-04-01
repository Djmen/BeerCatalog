//
//  ViewControllerBuilderImpl.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import Foundation

final class ViewControllerBuilderImpl: ViewControllerBuilder {
    let diContainer: DIContainer

    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }
}
