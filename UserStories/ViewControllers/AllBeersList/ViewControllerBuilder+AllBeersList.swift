//
//  ViewControllerBuilder+AllBeersList.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import class UIKit.UIViewController

extension ViewControllerBuilder {
    func allBeersList(delegate: AllBeersListDelegate) -> UIViewController {
        let viewModel = AllBeersListViewModel(delegate: delegate,
                                              beerService: diContainer.beerService,
                                              notificationManager: diContainer.notificationManager)
        return AllBeersListViewController(viewModel: viewModel)
    }
}

protocol AllBeersListDelegate: class {
    func showDetails(for beer: Beer)
}
