//
//  PairsViewModel.swift
//  Currencies
//
//  Created by macbook air on 28/05/2019.
//  Copyright © 2019 Artem Lytkin. All rights reserved.
//

import UIKit

class MainViewModel {
    
    let apiService: MainServiceProtocol
    
    var isEmpty: Bool {
        get {
            return pairs.isEmpty
        }
    }
    
    var count: Int {
        get {
            return pairs.count
        }
    }
    
    var alertMessage: String? {
        didSet {
            guard let message = alertMessage else { return }
            showAlertClosure?(message)
        }
    }
    
    private(set) var pairs: [Pair] = [] {
        didSet {
            if pairs.isEmpty { return }
            showPairListScreen?()
        }
    }
    
    var pairListVCIndex = 1
    
    // MARK: - Binding
    
    var showPairListScreen: EmptyClosure?
    var showAlertClosure: ErrorClosure?
    
    // MARK: - Lifecycle
    
    init(apiService: MainServiceProtocol = MainService()) {
        self.apiService = apiService
        
        pairs = apiService.loadPairs()
    }
    
    // MARK: - Public
    
    public func initData() {
        if pairs.isEmpty { return }
        showPairListScreen?()
    }
    
    public func didSelect(viewController: Any) {
        if let receiver = viewController as? Receiver {
            receiver.receive(pairs)
            pairs.removeAll()
        }
    }
    
    public func fetchPair(first: Currency, second: Currency) {
        let pairName = first.shortName + second.shortName
        apiService.fetchPair(pairName: pairName) {[weak self] (pairs, error) in
            guard error == nil,
                let unwrappedPairs = pairs else {
                    
                    if let errorMessage = error?.rawValue {
                        self?.alertMessage = errorMessage
                    }
                    
                    return
            }
            
            self?.pairs.append(contentsOf: unwrappedPairs)
        }
    }
    
}
