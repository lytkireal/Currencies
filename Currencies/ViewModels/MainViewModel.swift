//
//  PairsViewModel.swift
//  Currencies
//
//  Created by macbook air on 28/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import Foundation

class MainViewModel {
    
    let apiService: PairsServiceProtocol
    
    var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    private var pairs: [Pair] = [] {
        didSet {
            if pairs.isEmpty { return }
            showPairListScreen?()
        }
    }
    
    var pairListVCIndex = 1
    
    // MARK: - Binding
    
    var showPairListScreen: EmptyClosure?
    var showAlertClosure: EmptyClosure?
    
    // MARK: - Lifecycle
    
    init(apiService: PairsServiceProtocol = PairsService()) {
        self.apiService = apiService
    }
    
    // MARK: - Public
    
    public func didSelect(viewController: Any) {
        if let receiver = viewController as? Receiver {
            receiver.receive(pairs)
        }
    }
    
    public func fetchPair(first: Currency, second: Currency) {
        let pairList = [first.shortName + second.shortName]
        apiService.fetchPairsList(pairNames: pairList) {[weak self] (pairs, error) in
            guard error == nil,
                let unwrappedPairs = pairs else {
                    
                    self?.alertMessage = error.debugDescription
                    return
            }
            
            self?.pairs = unwrappedPairs
        }
    }
    
}
