//
//  MainTabViewController.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/31/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import UIKit

final class MainTabViewController: UITabBarController {
    convenience init(beerListViewController: UIViewController,
                     randomBeerViewController: UIViewController,
                     favoritesViewController: UIViewController) {
        self.init()
        beerListViewController.tabBarItem.title = Strings.TabBarItems.all
        beerListViewController.tabBarItem.image = Assets.buttles.image
        
        randomBeerViewController.tabBarItem.title = Strings.TabBarItems.random
        randomBeerViewController.tabBarItem.image = Assets.random.image
        
        favoritesViewController.tabBarItem.title = Strings.TabBarItems.favorites
        favoritesViewController.tabBarItem.image = Assets.favorite.image
        viewControllers = [beerListViewController, randomBeerViewController, favoritesViewController]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
