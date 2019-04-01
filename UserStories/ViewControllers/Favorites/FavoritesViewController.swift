//
//  FavoritesViewController.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class FavoritesViewController: UIViewController {
    private enum Constant {
        static let debounceInterval = 0.5
    }

    private let viewModel: FavoritesViewModel
    private let tableView = UITableView()
    private let footerView = ActivityFooterView()

    private let disposeBag = DisposeBag()

    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBinding()
        setupFooterBinding()
    }

    private func setupTableView() {
        tableView.register(BeerTableViewCell.self)
        tableView.tableFooterView = footerView
        view.insertAndFill(tableView)
    }

    private func setupBinding() {
        viewModel.favoritesBeers.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: BeerTableViewCell.defaultReuseIdentifier, cellType: BeerTableViewCell.self)) { _, beer, cell in
                cell.config(with: beer)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.asDriver()
            .do(onNext: { [unowned self] indexPatrh in
                self.tableView.deselectRow(at: indexPatrh, animated: true)
            })
            .withLatestFrom(viewModel.favoritesBeers.asDriver()) { $1[$0.row] }
            .drive(viewModel.onSelectBeer.inputs)
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted.asDriver()
            .withLatestFrom(viewModel.favoritesBeers.asDriver()) { $1[$0.row].id }
            .drive(viewModel.removeFromFavorites.inputs)
            .disposed(by: disposeBag)
    }
    
    private func setupFooterBinding() {
        Driver.combineLatest(viewModel.favoritesBeers.asDriver().map { $0.isEmpty },
                             viewModel.fetchFavorites.executing.asDriver(onErrorJustReturn: false))
            .drive(onNext: { [weak self] isEmpty, isExecuting in
                guard let self = self else { return }
                
                if isEmpty {
                    self.footerView.infoLabel.text = isExecuting ? Strings.FooterView.fetching : Strings.FooterView.noFavorites
                    self.footerView.frame.size.height = self.tableView.bounds.height * 0.75
                } else {
                    self.footerView.infoLabel.text = isExecuting ? Strings.FooterView.fetching : nil
                    self.footerView.frame.size.height = self.footerView.intrinsicContentSize.height
                }
                
                let activityAction = isExecuting ? self.footerView.activityIndicator.startAnimating
                    : self.footerView.activityIndicator.stopAnimating
                activityAction()
            })
            .disposed(by: disposeBag)
    }
}
