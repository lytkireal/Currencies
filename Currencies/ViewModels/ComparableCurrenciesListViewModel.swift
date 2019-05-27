//
//  CurrenciesListViewModel.swift
//  Revolut
//
//  Created by Artem Lytkin on 27.08.2018.
//  Copyright © 2018 Artem Lytkin. All rights reserved.
//

import Foundation

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
    
    //var selectedCurrency: Currency?
    
    var showAlertClosure: EmptyClosure?
    
    var timer = Timer()
    
    var isAllowToTapOnCell: Bool = false
    
    // MARK: - Lifecycle
    
    init(currencies: [Currency]) {
        self.currencies = currencies
        processFetchedCurrencies(currencies: currencies)
    }
    
    // MARK: - Public
    
    public func userPressed(at indexPath: IndexPath) {
        
    }
    
    public func getCellViewModel(at indexPath: IndexPath) -> CurrencyListCellViewModel {
        
        let cellViewModel = cellViewModels[indexPath.row]
        
        return cellViewModel
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






















































