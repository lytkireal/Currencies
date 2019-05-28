//
//  PairsViewModel.swift
//  Currencies
//
//  Created by Artem Lytkin on 27/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import Foundation

struct PairsListCellViewModel {
    let titleText: String
    let decriptionText: String
    var value: String
    var isSelected: Bool
}

class PairsViewModel {
    
    // MARK: - Properties
    
    let apiService: PairsServiceProtocol
    
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
    
    // MARK: - Binding
    
    var reloadTableViewClosure: EmptyClosure?
    var showAlertClosure: EmptyClosure?
    var showComparableCurrenciesScreen: ( (_ selectedIndexPath: IndexPath) -> Void )?
    
    // MARK: - Lifecycle
    
    init(apiService: PairsServiceProtocol = PairsService()) {
        self.apiService = apiService
    }
    
    // MARK: - Public
    
    public func userPressed(at indexPath: IndexPath) {
        currencies[indexPath.row].isSelected = true
        showComparableCurrenciesScreen?(indexPath)
    }
    
    public func initFetch() {
        apiService.fetchPairsList(pairName: "GBPUSD") { pairs, error in
            print(pairs)
        }
        //apiService.fet { currencies in
        //    self.processFetchedCurrencies(currencies: currencies)
        //}
    }
    
    public func getCellViewModel(at indexPath: IndexPath) -> CurrencyListCellViewModel {
        let cellViewModel = cellViewModels[indexPath.row]
        
        return cellViewModel
    }
    
    public func getModelForComparableCurrenciesListVC(forRowAt indexPath: IndexPath) -> ComparableCurrenciesListViewModel {
        return ComparableCurrenciesListViewModel(currencies: currencies, comparableCurrency: currencies[indexPath.row])
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
