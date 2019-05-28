//
//  CurrenciesListViewModel.swift
//  Revolut
//
//  Created by Artem Lytkin on 27.08.2018.
//  Copyright © 2018 Artem Lytkin. All rights reserved.
//

import UIKit

class ComparableCurrenciesListViewModel {
    
    // MARK: - Properties
    
    private var currencies: [Currency] = [] 
    private var cellViewModels: [CurrencyListCellViewModel] = []
    
    var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return currencies.count
    }
    
    private var firstCurrencyInPair: Currency
    private var secondCurrencyInPair: Currency?
    
    // MARK: - Binding
    
    var showAlertClosure: EmptyClosure?
    var sendPairsClosure: EmptyClosure?
    
    // MARK: - Lifecycle
    
    init(currencies: [Currency], comparableCurrency: Currency) {
        self.currencies = currencies
        self.firstCurrencyInPair = comparableCurrency
        processFetchedCurrencies(currencies: currencies)
    }
    
    // MARK: - Public
    
    public func userPressed(at indexPath: IndexPath) {
        secondCurrencyInPair = currencies[indexPath.row]
        sendPairsClosure?()
    }
    
    public func getCellViewModel(at indexPath: IndexPath) -> CurrencyListCellViewModel {
        
        let cellViewModel = cellViewModels[indexPath.row]
        
        return cellViewModel
    }
    
    public func calledSegue(to viewController: UIViewController) {
        guard let pairsFetcher = viewController as? PairsFetcher,
            let secondCurrency = secondCurrencyInPair
            else { return }

        pairsFetcher.fetchPair(first: firstCurrencyInPair, second: secondCurrency)
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






















































