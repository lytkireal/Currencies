//
//  CurrenciesListViewModel.swift
//  Revolut
//
//  Created by Artem Lytkin on 27.08.2018.
//  Copyright © 2018 Artem Lytkin. All rights reserved.
//

import Foundation

enum CurrenciesListViewModelModes  {
    case allRates
    case converter
}

struct CurrencyListCellViewModel {
    let titleText: String
    let decriptionText: String
    var value: String
    var isSelected: Bool
}

class CurrenciesListViewModel {
    
    // MARK: - Properties
    
    let apiService: APIServiceProtocol
    
    private var currencies: [Currency] = [] {
        didSet {
            if oldValue.count != currencies.count {
                reloadTableViewClosure?()
            }
        }
    }
    
    private var cellViewModels: [CurrencyListCellViewModel] = [] {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return currencies.count
    }
    
    var selectedCurrency: Currency?
    
    var reloadTableViewClosure: EmptyClosure?
    var showAlertClosure: EmptyClosure?
    var showComparableCurrenciesScreen: EmptyClosure?
    
    var timer = Timer()
    
    var amountOfMoneyInEuro: Double = 10.0
    
    var mode: CurrenciesListViewModelModes = .allRates {
        didSet {
            if mode == .allRates {
                reloadTableViewClosure?()
                isAllowToTapOnCell = false
            } else {
                isAllowToTapOnCell = true
            }
            amountOfMoneyInEuro = 10.0
            selectedCurrency = nil
        }
    }
    
    var isAllowToTapOnCell: Bool = false
    
    // MARK: - Lifecycle
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    // MARK: - Public
    
    public func userPressed(at indexPath: IndexPath) {
        currencies[indexPath.row].isSelected = true
        showComparableCurrenciesScreen?()
    }
    
    public func initFetch() {
        apiService.loadCurrenciesList { currencies in
            self.processFetchedCurrencies(currencies: currencies)
        }
    }
    
    public func getCellViewModel(at indexPath: IndexPath) -> CurrencyListCellViewModel {
        let cellViewModel = cellViewModels[indexPath.row]
        
        return cellViewModel
    }
    
    public func getModelForComparableCurrenciesListVC() -> ComparableCurrenciesListViewModel {
        return ComparableCurrenciesListViewModel(currencies: currencies)
    }
    
    // MARK: - Private
    
    private func processFetchedCurrencies(currencies: [Currency]) {
        self.currencies = currencies
        var cellViewModels = [CurrencyListCellViewModel]()
        
        for currency in currencies {
            let currencyLongName = currency[currency.shortName] ?? ""
            let currencyListCellViewModel = CurrencyListCellViewModel(titleText: currency.shortName,
                                                                      decriptionText: currencyLongName,
                                                                      value: "0",
                                                                      isSelected: currency.isSelected)
            cellViewModels.append(currencyListCellViewModel)
        }
        self.cellViewModels = cellViewModels
    }
}






















































