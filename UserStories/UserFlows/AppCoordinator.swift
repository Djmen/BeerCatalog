//
//  AppCoordinator.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let viewControllerBuilder: ViewControllerBuilder
    private var detailsCoordinator: Coordinator?
    
    private lazy var randomDetailsViewController = UINavigationController(rootViewController: viewControllerBuilder.beerDetails(delegate: self, type: .random))
    private lazy var tabBarViewController = MainTabViewController(beerListViewController: viewControllerBuilder.allBeersList(delegate: self),
                                                                  randomBeerViewController: randomDetailsViewController,
                                                                  favoritesViewController: viewControllerBuilder.favorites(delegate: self))
    private lazy var rootViewController = UINavigationController(rootViewController: tabBarViewController)


    init(window: UIWindow, viewControllerBuilder: ViewControllerBuilder) {
        self.window = window
        self.viewControllerBuilder = viewControllerBuilder
    }
}

extension AppCoordinator: Coordinator {
    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: AllBeersListDelegate, FavoritesDelegate {
    func showDetails(for beer: Beer) {
        detailsCoordinator = DetailsCoordinator(viewControllerBuilder: viewControllerBuilder, parentViewController: tabBarViewController, beer: beer)
        detailsCoordinator?.start()
    }
}

extension AppCoordinator: BeerDetailsDelegate {
    
}
