//
//  AppDelegate.swift
//  Currencies
//
//  Created by Artem Lytkin on 24/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import Foundation

class ComparableCurrencyListViewModel {
    
    // MARK: - Properties
    
    private var currencies: [Currency] = [] 
    private var cellViewModels: [CurrencyListCellViewModel] = []
    
    var alertMessage: String? {
        didSet {
            guard let message = alertMessage else { return }
            showAlertClosure?(message)
        }
    }
    
    var numberOfCells: Int {
        return currencies.count
    }
    
    private var firstCurrencyInPair: Currency
    private var secondCurrencyInPair: Currency?
    
    // MARK: - Binding
    
    var showAlertClosure: ErrorClosure?
    var sendPairsClosure: EmptyClosure?
    
    // MARK: - Lifecycle
    
    init(currencies: [Currency], comparableCurrency: Currency) {
        self.currencies = currencies
        self.firstCurrencyInPair = comparableCurrency
        processFetchedCurrencies(currencies: currencies)
    }
}

// MARK: - Methods.Public

extension ComparableCurrencyListViewModel {
    
    public func userPressed(at indexPath: IndexPath) {
        secondCurrencyInPair = currencies[indexPath.row]
        sendPairsClosure?()
    }
    
    public func getCellViewModel(at indexPath: IndexPath) -> CurrencyListCellViewModel {
        
        let cellViewModel = cellViewModels[indexPath.row]
        
        return cellViewModel
    }
    
    public func calledSegue(to viewController: Any) {
        guard let pairsFetcher = viewController as? PairsFetcher,
            let secondCurrency = secondCurrencyInPair
            else { return }
        
        pairsFetcher.fetchPair(first: firstCurrencyInPair, second: secondCurrency)
    }
}

// MARK: - Methods.Private

extension ComparableCurrencyListViewModel {
    
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
}



















































