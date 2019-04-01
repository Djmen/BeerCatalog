//
//  ViewControllerBuilder+BeerDetails.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import class UIKit.UIViewController

extension ViewControllerBuilder {
    func beerDetails(delegate: BeerDetailsDelegate, type: BeerDetailsViewModel.DetailsType) -> UIViewController {
        let viewModel = BeerDetailsViewModel(delegate: delegate,
                                             type: type,
                                             beerService: diContainer.beerService,
                                             notificationManager: diContainer.notificationManager)
        return BeerDetailsViewController(viewModel: viewModel)
    }
}

protocol BeerDetailsDelegate: class {
    
}
