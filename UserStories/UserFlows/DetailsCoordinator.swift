//
//  DetailsCoordinator.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/31/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import UIKit

final class DetailsCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let parentViewController: UIViewController
    private let beer: Beer
    
    init(viewControllerBuilder: ViewControllerBuilder, parentViewController: UIViewController, beer: Beer) {
        self.viewControllerBuilder = viewControllerBuilder
        self.parentViewController = parentViewController
        self.beer = beer
    }
}

extension DetailsCoordinator: Coordinator {
    func start() {
        let detailsViewController = viewControllerBuilder.beerDetails(delegate: self, type: .particular(beer))
        parentViewController.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension DetailsCoordinator: BeerDetailsDelegate {}
