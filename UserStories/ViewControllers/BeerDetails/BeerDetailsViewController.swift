//
//  BeerDetailsViewController.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class BeerDetailsViewController: UIViewController {
    private enum Constants {
        static let horizontalPadding: CGFloat = 20.0
        static let spacing: CGFloat = 12.0
        static let setFavoriteTitle = "☆"
        static let removeFavoriteTitle = "★"
    }

    private let viewModel: BeerDetailsViewModel
    private let disposeBag = DisposeBag()
    private let scrollView = UIScrollView()
    private var reloadRandomButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
    lazy private var reloadActivityItem = UIBarButtonItem(customView: activityIndicator)
    private var favoriteButtonItem = UIBarButtonItem(title: Constants.setFavoriteTitle, style: .plain, target: nil, action: nil)

    private let imageView = UIImageView()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()

    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    init(viewModel: BeerDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.insertAndFill(scrollView)
        
        let stack = UIStackView(arrangedSubviews: [imageView, nameLabel, detailsLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        let container = UIView()
        container.insertAndFill(stack, inset: Constants.horizontalPadding)
        scrollView.insertAndFill(container)
        container.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true

        navigationItem.rightBarButtonItem = favoriteButtonItem
        if case .random = viewModel.type {
            navigationItem.leftBarButtonItem = reloadRandomButton
        }
    }

    private func setupBinding() {
        viewModel.beer
            .subscribe(onNext: { [weak self] beer in
                guard let self = self, let beer = beer else { return }
                self.imageView.sd_setImage(with: beer.imageURL, placeholderImage: Assets.imagePlaceholder.image, options: [.retryFailed], completed: nil)
                self.title = beer.name
                self.nameLabel.text = beer.name
                self.detailsLabel.text = beer.description
            })
            .disposed(by: disposeBag)
        
        if case .random = viewModel.type {
            setupBindingForReloadButton()
        }
        setupFavoriteButtonBinding()
    }
    
    func setupBindingForReloadButton() {
        viewModel.loadRandomBeer.executing
            .subscribe(onNext: { [weak self] executing in
                guard let self = self else { return }
                if executing {
                    self.navigationItem.leftBarButtonItem = self.reloadActivityItem
                    self.activityIndicator.startAnimating()
                } else {
                    self.navigationItem.leftBarButtonItem = self.reloadRandomButton
                }
                self.favoriteButtonItem.isEnabled = !executing
            })
            .disposed(by: disposeBag)
        
        reloadRandomButton.rx.action = viewModel.loadRandomBeer
    }

    func setupFavoriteButtonBinding() {
        viewModel.isFavorite
            .subscribe(onNext: { [unowned self] isFavorite in
                self.favoriteButtonItem.title = isFavorite ? Constants.removeFavoriteTitle : Constants.setFavoriteTitle
                self.favoriteButtonItem.rx.action = isFavorite ? self.viewModel.removeFromFavorites : self.viewModel.addToFavorites
            })
            .disposed(by: disposeBag)
    }
}
