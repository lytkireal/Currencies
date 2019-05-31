//
//  CurrenciesListViewModel.swift
//  Revolut
//
//  Created by Artem Lytkin on 27.08.2018.
//  Copyright © 2018 Artem Lytkin. All rights reserved.
//

import Foundation

struct CurrencyListCellViewModel {
    let titleText: String
    let decriptionText: String
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
    
    private var pairs: [Pair] = []
    
    var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return currencies.count
    }
    
    // MARK: - Binding
    
    var reloadTableViewClosure: EmptyClosure?
    var showAlertClosure: EmptyClosure?
    var showComparableCurrenciesScreen: ( (_ selectedIndexPath: IndexPath) -> Void )?
    
    // MARK: - Lifecycle
    
    init(apiService: APIServiceProtocol = CurrenciesService()) {
        self.apiService = apiService
    }
    
    // MARK: - Public
    
    public func receive(_ data: Any) {
        if let pairList = data as? [Pair] {
            pairs = pairList
        }
    }
    
    public func userPressed(at indexPath: IndexPath) {
        currencies[indexPath.row].isSelected = true
        showComparableCurrenciesScreen?(indexPath)
    }
    
    private func prepareCurrenciesForComparable() {
        
    }
    
    public func initFetch() {
        apiService.loadCurrenciesList { [weak self] currencies, error in
            
            guard error == nil,
                let unwrappedCurrencies = currencies else {
                
                    self?.alertMessage = error.debugDescription
                    return
            }
            self?.processFetchedCurrencies(currencies: unwrappedCurrencies)
        }
    }
    
    public func getCellViewModel(at indexPath: IndexPath) -> CurrencyListCellViewModel {
        let cellViewModel = cellViewModels[indexPath.row]
        
        return cellViewModel
    }
    
    public func getModelForComparableCurrenciesListVC(forRowAt indexPath: IndexPath) -> ComparableCurrenciesListViewModel {
        let comparableCurrency = currencies[indexPath.row]
        
        let currencies = prepareCurrencies(withComparable: comparableCurrency)
        
        return ComparableCurrenciesListViewModel(currencies: currencies, comparableCurrency: comparableCurrency)
    }
    
    // MARK: - Private
    
    private func processFetchedCurrencies(currencies: [Currency]) {
        self.currencies = currencies
        var cellViewModels: [CurrencyListCellViewModel] = []
        
        for currency in currencies {
            let currencyListCellViewModel = CurrencyListCellViewModel(titleText: currency.shortName,
                                                                      decriptionText: currency.longName,
                                                                      isSelected: currency.isSelected)
            cellViewModels.append(currencyListCellViewModel)
        }
        self.cellViewModels = cellViewModels
    }
    
    private func prepareCurrencies(withComparable currency: Currency) -> [Currency] {
        
        var alreadyComparedCurrencies: [Currency] = []
        
        for pair in pairs {
            if pair.main == currency {
                alreadyComparedCurrencies.append(pair.secondary)
            }
        }
        
        for currency in currencies {
            for comparedCurrency in alreadyComparedCurrencies {
                if currency == comparedCurrency {
                    currency.isSelected = true
                }
            }
        }
        
        return currencies
    }
}






















































