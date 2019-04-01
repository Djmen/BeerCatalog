//
//  InAppNotificationManager.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/31/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import Foundation

protocol InAppNotificationManager {
    func showMessage(_ message: String)
    func showError(_ message: String)
    func showError(_ error: Error)
}
