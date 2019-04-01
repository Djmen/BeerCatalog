//
//  AllBeersListViewController.swift
//  BeerCatalog
//
//  Created by Evgeniy Gutorov on 3/30/19.
//  Copyright © 2019 Evgeniy Gutorov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class AllBeersListViewController: UIViewController {
    private enum Constant {
        static let debounceInterval = 0.5
        static let firstPage = 1
    }
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.barTintColor = .white
        searchBar.placeholder = Strings.SearchBar.placeholder
        return searchBar
    }()
    
    private let footerView = ActivityFooterView()
    private let tableView = UITableView()

    private let viewModel: AllBeersListViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: AllBeersListViewModel) {
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
    }
    
    private func showNextPage() {
        viewModel.loadBeers.execute((page: viewModel.nextPage, searchText: searchBar.text))
    }
    
    private func setupTableView() {
        tableView.keyboardDismissMode = .onDrag
        tableView.tableHeaderView = searchBar
        tableView.tableFooterView = footerView
        tableView.register(BeerTableViewCell.self)
        view.insertAndFill(tableView)
    }
    
    private func setupBinding() {
        setupTableViewBinding()
        setupSearchBarBinding()
        setupFooterBinding()
    }
    
    private func setupTableViewBinding() {
        viewModel.beers.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: BeerTableViewCell.defaultReuseIdentifier, cellType: BeerTableViewCell.self)) { [weak self] row, beer, cell in
                cell.config(with: beer)

                if let count = self?.viewModel.beers.value.count, row == count - 1  {
                    self?.showNextPage()
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.asDriver().withLatestFrom(viewModel.beers.asDriver()) { $1[$0.row] }
            .debounce(Constant.debounceInterval)
            .drive(viewModel.onSelectBeer.inputs)
            .disposed(by: disposeBag)
    }
    
    private func setupSearchBarBinding() {
        searchBar.rx.text.orEmpty.asDriver()
            .distinctUntilChanged()
            .debounce(Constant.debounceInterval)
            .map { text -> FetchRequest in (page: Constant.firstPage, searchText: text) }
            .drive(viewModel.loadBeers.inputs)
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked.withLatestFrom(searchBar.rx.text)
            .asDriver(onErrorJustReturn: nil)
            .distinctUntilChanged()
            .map { text -> FetchRequest in (page: Constant.firstPage, searchText: text) }
            .drive(viewModel.loadBeers.inputs)
            .disposed(by: disposeBag)
    }
    
    private func setupFooterBinding() {
        Driver.combineLatest(viewModel.beers.asDriver().map { $0.isEmpty },
                             viewModel.loadBeers.executing.asDriver(onErrorJustReturn: false))
            .drive(onNext: { [weak self] isEmpty, isExecuting in
                guard let self = self else { return }
                
                if isEmpty {
                    self.footerView.infoLabel.text = isExecuting ? Strings.FooterView.fetching : Strings.FooterView.emptyData
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
