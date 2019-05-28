//
//  ListOfPairsViewModel.swift
//  Currencies
//
//  Created by Artem Lytkin on 28/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import Foundation

struct PairsListCellViewModel {
    let titleText: String
    let decriptionText: String
    var value: String
    var isSelected: Bool
}

class ListOfPairsViewModel {
    
    let apiService: PairsServiceProtocol
    
    var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    private var pairs: [Pair] = []
    
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
    
    private func fetchPairs(_ pairs: [Pair]) {

        let pairNames: [String] = pairs.map {
            return $0.main.shortName + $0.secondary.shortName
        }
        
        apiService.fetchPairsList(pairNames: pairNames) {[weak self] (pairs, error) in
            guard error == nil,
                let unwrappedPairs = pairs else {
                    
                    self?.alertMessage = error.debugDescription
                    return
            }
            
            self?.pairs = unwrappedPairs
        }
    }
}
