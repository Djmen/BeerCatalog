//
//  BeerTableViewCell.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/31/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import UIKit
import SDWebImage

final class BeerTableViewCell: UITableViewCell {
    private enum Constants {
        static let spacing: CGFloat = 12
        static let imageHeight: CGFloat = 44
    }
    
    private let beerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        return label
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        resetUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        resetUI()
        beerImageView.sd_cancelCurrentImageLoad()
    }

    func config(with beer: Beer) {
        titleLabel.text = beer.name
        taglineLabel.text = beer.tagline
        beerImageView.sd_setImage(with: beer.imageURL,
                               placeholderImage: Assets.imagePlaceholder.image,
                               options: [.retryFailed],
                               completed: nil)
    }
    
    private func setupUI() {
        layoutMargins.left = Constants.imageHeight + Constants.spacing
        
        beerImageView.translatesAutoresizingMaskIntoConstraints = false
        beerImageView.widthAnchor.constraint(equalTo: beerImageView.heightAnchor).isActive = true
        beerImageView.widthAnchor.constraint(equalToConstant: Constants.imageHeight).isActive = true
        
        let labelsStack = UIStackView(arrangedSubviews: [titleLabel, taglineLabel])
        labelsStack.alignment = .leading
        labelsStack.axis = .vertical
        labelsStack.distribution = .fillEqually
        
        let stack = UIStackView(arrangedSubviews: [beerImageView, labelsStack])
        stack.spacing = Constants.spacing
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.spacing).isActive = true
        stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.spacing).isActive = true
    }

    private func resetUI() {
        titleLabel.text = ""
        taglineLabel.text = ""
        beerImageView.image = Assets.imagePlaceholder.image
    }
}
