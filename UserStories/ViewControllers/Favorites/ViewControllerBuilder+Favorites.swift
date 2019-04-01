//
//  ViewControllerBuilder.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import class UIKit.UIViewController

extension ViewControllerBuilder {
    func favorites(delegate: FavoritesDelegate) -> UIViewController {
        let viewModel = FavoritesViewModel(delegate: delegate,
                                           beerService: diContainer.beerService,
                                           notificationManager: diContainer.notificationManager)
        return FavoritesViewController(viewModel: viewModel)
    }
}

protocol FavoritesDelegate: class {
    func showDetails(for beer: Beer)
}
