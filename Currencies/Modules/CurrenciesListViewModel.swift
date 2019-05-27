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

class CurrenciesListViewModel {
    
    // MARK: - Properties
    
    let apiService: APIServiceProtocol
    
    private var currencies: [Currency] = [] {
        didSet {
            if oldValue.count != currencies.count {
                reloadTableViewClosure?()
            } else {
                updateCurrenciesValuesLabelsClosure?()
            }
        }
    }
    
    private var cellViewModels: [CurrencyListCellViewModel] = [] {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            updateLoadingStatusClosure?()
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
    
    var reloadTableViewClosure: ( () -> Void )?
    var updateLoadingStatusClosure: ( () -> Void )?
    var showAlertClosure: ( () -> Void )?
    var updateCurrenciesValuesLabelsClosure: ( () -> Void )?
    var moveCellToTopClosure: ( ( _ indexPath: IndexPath ) -> Void )?
    var tapOnCellClosure: ( ( _ selectedCells: [IndexPath] ) -> Void )?
    
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
        currencies[indexPath.row].selected = true
    }
    
    public func initFetch() {
        apiService.loadCurrenciesList { currencies in
            self.processFetchedCurrencies(currencies: currencies)
        }
    }
    
    public func createCellViewModel(currency: Currency) -> CurrencyListCellViewModel {
        let titleText = currency.shortName
        let value = String(format: "%.2f", currency.coefficient).replacingOccurrences(of: ".", with: ",")
        
        return CurrencyListCellViewModel(titleText: titleText,
                                         decriptionText: currency[currency.shortName] ?? "",
                                         value: value)
    }
    
    public func getCellViewModel(at indexPath: IndexPath) -> CurrencyListCellViewModel {
        
        var cellViewModel = cellViewModels[indexPath.row]
        
        if mode == .converter {
            //cellViewModel.value = String(format: "%.2f", currencies[indexPath.row].coefficient * amountOfMoneyInEuro).replacingOccurrences(of: ".", with: ",")
        } 
        
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
                                                                      value: "0")
            cellViewModels.append(currencyListCellViewModel)
        }
        self.cellViewModels = cellViewModels
    }
    
    func changeAmountOfMoneyWithNewValues( old: Double, new: Double ) {
        if mode == .converter {
            let selectedCurrencyValueExchangingInPercentage = ( new - old ) / ( old )
            print(selectedCurrencyValueExchangingInPercentage)
            amountOfMoneyInEuro += amountOfMoneyInEuro * selectedCurrencyValueExchangingInPercentage
        }
    }
}






















































