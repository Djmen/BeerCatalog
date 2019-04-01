//
//  UITableView+RegisterCell.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/31/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import UIKit

public extension UITableView {
    /**
     The shorter method for cell registering
     */
    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    /**
     The shorter method for reusable cell registering
     */
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>() -> T {
        guard let castedHeader = dequeueReusableHeaderFooterView(withIdentifier: T.className) as? T else {
            fatalError("Dequeueing header or footer of type \(T.className) failed. Maybe cell isn't registered in UITableView \(self)")
        }
        return castedHeader
    }
}

public extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}

public extension UITableViewHeaderFooterView {
    static func register(in tableView: UITableView) {
        tableView.register(self, forHeaderFooterViewReuseIdentifier: className)
    }
}
