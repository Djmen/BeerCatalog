//
//  UIView+FIll.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 4/1/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import struct UIKit.CGFloat
import class UIKit.UIView
import struct UIKit.UIEdgeInsets

extension UIView {
    func insertAndFill(_ subview: UIView, insets: UIEdgeInsets = .zero) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom).isActive = true
    }

    func insertAndFill(_ subview: UIView, inset: CGFloat) {
        insertAndFill(subview, insets: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
    }

    func insertAtCenter(_ subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
