//
//  ActivityFooterView.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/31/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import UIKit

final class ActivityFooterView: UIView {
    private enum Constants {
        static let spacing: CGFloat = 12.0
        static let horizontalPadding: CGFloat = 20.0
        static let verticalPadding: CGFloat = 12.0
    }
    
    let infoLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView()
    
    override var intrinsicContentSize: CGSize {
        let contentWidth = UIScreen.main.bounds.width - Constants.horizontalPadding*2.0
        let height = Constants.verticalPadding +
                     infoLabel.sizeThatFits(CGSize(width: contentWidth, height: CGFloat.greatestFiniteMagnitude)).height +
                     Constants.spacing +
                     activityIndicator.intrinsicContentSize.height +
                     Constants.verticalPadding
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setupLabel()
        setupActivityIndicator()
        
        let stack = UIStackView(arrangedSubviews: [activityIndicator, infoLabel])
        stack.alignment = .center
        stack.distribution = .fill
        stack.axis = .vertical
        stack.spacing = Constants.spacing

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding).isActive = true
        stack.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: Constants.verticalPadding).isActive = true
    }

    private func setupLabel() {
        infoLabel.textAlignment = .center
        infoLabel.textColor = .gray
        infoLabel.numberOfLines = 0
    }

    private func setupActivityIndicator() {
        activityIndicator.style = .whiteLarge
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.sizeToFit()
    }
}
