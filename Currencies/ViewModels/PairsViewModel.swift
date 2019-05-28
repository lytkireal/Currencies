//
//  PairsViewModel.swift
//  Currencies
//
//  Created by macbook air on 28/05/2019.
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
    
    let apiService: PairsServiceProtocol
    
    var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    // MARK: - Binding
    
    var reloadTableViewClosure: EmptyClosure?
    var showAlertClosure: EmptyClosure?
    
    // MARK: - Lifecycle
    
    init(apiService: PairsServiceProtocol = PairsService()) {
        self.apiService = apiService
    }
    
    // MARK: - Public
    
    public func initFetch() {
        // TODO: - Make loading of saved currency pairs
//        apiService.fetchPairsList(pairName: <#T##String#>, completion: <#T##([String : Float]?, APIError?) -> Void#>) { [weak self] currencies, error in
//
//            guard error == nil,
//                let unwrappedCurrencies = currencies else {
//
//                    self?.alertMessage = error.debugDescription
//                    return
//            }
//            self?.processFetchedCurrencies(currencies: unwrappedCurrencies)
//        }
    }
    
    public func fetchPair(first: Currency, second: Currency) {
        let pairList = [first.shortName + second.shortName]
        apiService.fetchPairsList(pairNames: pairList) {[weak self] (pairs, error) in
            guard error == nil,
                let unwrappedPairs = pairs else {
                    
                    self?.alertMessage = error.debugDescription
                    return
            }
            
            print(unwrappedPairs)
        }
    }
    
    public func fetchPairsList(pairNames: [String]) {
//        apiService.fetchPairsList(pairNames: pairNames) {[weak self] (pairs, error) in
//            guard error == nil,
//                let unwrappedPairs = pairs else {
//
//                self?.alertMessage = error.debugDescription
//                return
//            }
//
//            print(unwrappedPairs)
//        }
    }
    
}
